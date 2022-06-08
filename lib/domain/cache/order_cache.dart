import 'dart:async';
import 'dart:developer' as dev;

import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../model/order/order.dart';
import '../model/order/order_group.dart';
import '../model/order/order_update.dart';
import '../model/restaurant.dart';
import '../model/table_entity.dart';
import '../repository/order_repository.dart';

abstract class OrderCache implements Disposable {
  void listenOnOrderUpdates(Restaurant restaurant);

  Stream<Map<TableEntity, List<OrderGroup>>> orderGroupList();

  Future<void> groupSimilarOrders(
    TableEntity table, {
    Duration interval = Restaurant.defaultOrderGroupWarningInterval,
    Future<bool> Function(Duration)? shouldGroupBeyondInterval,
  });
}

@LazySingleton(as: OrderCache)
class OrderCacheImpl implements OrderCache {
  final OrderRepository _repository;

  OrderCacheImpl(this._repository);

  StreamSubscription? _listener;
  final Map<TableEntity, List<OrderGroup>> _tableOrderGroupMap = {};
  final _orderGroupController =
      BehaviorSubject<Map<TableEntity, List<OrderGroup>>>();

  @override
  void listenOnOrderUpdates(Restaurant restaurant) {
    _listener?.cancel();
    _listener = _repository.onOrderListUpdated(restaurant).listen((updateList) {
      for (final update in updateList) {
        _process(update);
      }
      _orderGroupController.add(_tableOrderGroupMap);
    });
  }

  @override
  Stream<Map<TableEntity, List<OrderGroup>>> orderGroupList() =>
      _orderGroupController.stream;

  @override
  FutureOr onDispose() {
    _listener?.cancel();
  }

  void _process(OrderUpdate update) {
    final order = update.order;
    switch (update.type) {
      case OrderUpdateType.added:
        _tableOrderGroupMap.addOrder(order);
        break;
      case OrderUpdateType.modified:
        _tableOrderGroupMap.modifyOrder(order);
        break;
      case OrderUpdateType.removed:
        final group = _tableOrderGroupMap.removeOrder(order);
        if (group == null) break;
        final table = update.order.table;
        if (group.orderList.isEmpty) _tableOrderGroupMap[table]?.remove(group);
        break;
    }
    dev.log('Processed $update');
  }

  @override
  Future<void> groupSimilarOrders(
    TableEntity table, {
    Duration interval = Restaurant.defaultOrderGroupWarningInterval,
    Future<bool> Function(Duration)? shouldGroupBeyondInterval,
  }) async {
    final orderList = _tableOrderGroupMap[table];
    if (orderList == null || orderList.isEmpty) return;

    bool? shouldGroup;
    final result = <OrderGroup>[];
    for (final group in orderList) {
      final existing = result.firstWhereOrNull(
        (e) =>
            e.recipe.name == group.recipe.name &&
            e.phase == group.phase &&
            e.currentStatus == group.currentStatus &&
            e.customNote == group.customNote,
      );
      if (existing == null) {
        result.add(group);
      } else {
        if (existing.createdAt.difference(group.createdAt).inSeconds.abs() >
            interval.inSeconds) {
          shouldGroup ??=
              await shouldGroupBeyondInterval?.call(interval) ?? true;
          if (shouldGroup) {
            existing.orderList.addAll(group.orderList);
          } else {
            result.add(group);
          }
        } else {
          existing.orderList.addAll(group.orderList);
        }
      }
    }
    _tableOrderGroupMap[table] = result;
    _orderGroupController.add(_tableOrderGroupMap);
  }
}

extension on Map<TableEntity, List<OrderGroup>> {
  void addOrder(Order order) {
    this[order.table] ??= <OrderGroup>[];
    this[order.table]?.add(OrderGroup([order]));
  }

  void modifyOrder(Order order) {
    _groupForOrder(order)?.modify(order);
  }

  OrderGroup? removeOrder(Order order) {
    final group = _groupForOrder(order);
    group?.remove(order);
    return group;
  }

  OrderGroup? _groupForOrder(Order order) {
    return this[order.table]?.firstWhereOrNull((e) => e.contains(order));
  }
}

extension on OrderGroup {
  bool contains(Order order) => orderList.contains(order);

  void remove(Order order) {
    orderList.remove(order);
    _sortOrders();
  }

  void modify(Order order) {
    orderList.remove(order);
    orderList.add(order);
    _sortOrders();
  }

  void _sortOrders() {
    orderList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }
}
