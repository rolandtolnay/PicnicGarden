import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart' hide Table, Notification;
import 'package:meta/meta.dart';
import 'package:picnicgarden/model/notification.dart';
import 'package:picnicgarden/provider/notification_provider.dart';

import '../../logic/api_response.dart';
import '../../logic/pg_error.dart';
import '../../model/order.dart';
import '../../model/order_status.dart';
import '../../model/table.dart';
import '../entity_provider.dart';

abstract class OrderProvider extends EntityProvider {
  UnmodifiableListView<Order> ordersForTable(Table table);

  Future<PGError> commitOrder(Order order);
  Future<PGError> commitNextFlow({
    @required Order order,
    @required List<OrderStatus> orderStatusList,
  });
}

class FIROrderProvider extends FIREntityProvider<Order>
    implements OrderProvider {
  final NotificationProvider _notificationProvider;

  FIROrderProvider({NotificationProvider notificationProvider})
      : _notificationProvider = notificationProvider,
        super('orders', (json) => Order.fromJson(json)) {
    response = ApiResponse.loading();
    listenOnSnapshots(collection.where('delivered', isNull: true));
  }

  @override
  UnmodifiableListView<Order> ordersForTable(Table table) =>
      UnmodifiableListView(
        entities.where((order) => order.table == table),
      );

  @override
  Future<PGError> commitOrder(Order order) async {
    final error = await postEntity(order.id, order.toJson());
    if (order.shouldNotifyStatus) {
      final notification = Notification.forOrder(order);
      return _notificationProvider.postNotification(notification);
    }
    return error;
  }

  @override
  Future<PGError> commitNextFlow({
    Order order,
    List<OrderStatus> orderStatusList,
  }) {
    final currentFlow = order.currentStatus.flow;
    final nextFlow = currentFlow + 1;
    if (nextFlow < orderStatusList.length) {
      // Update flow
      var lastFlowEndDate = order.created;
      final previousFlow = currentFlow - 1;
      if (previousFlow >= 0) {
        lastFlowEndDate = order.created.add(order.flow.values.reduce(
            (value, element) =>
                Duration(seconds: value.inSeconds + element.inSeconds)));
      }
      order.flow[order.currentStatus.name] = Duration(
        seconds: DateTime.now().difference(lastFlowEndDate).inSeconds,
      );
      // Update current status
      final nextStatus = orderStatusList[nextFlow];
      order.currentStatus = nextStatus;
      // Update delivered
      if (nextFlow == orderStatusList.length - 1) {
        order.delivered = DateTime.now();
      }
      return commitOrder(order);
    } else {
      return Future.value(null);
    }
  }
}
