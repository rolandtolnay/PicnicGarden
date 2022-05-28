import 'dart:async';

import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:picnicgarden/domain/model/order/order_update.dart';
import 'package:picnicgarden/domain/model/restaurant.dart';
import 'package:picnicgarden/domain/model/table_entity.dart';

import '../model/order/order.dart';
import '../model/order/order_group.dart';
import '../repository/order_repository.dart';

import 'dart:developer' as dev;

abstract class OrderCache implements Disposable {
  void listenOnOrderUpdates(Restaurant restaurant);

  Iterable<OrderGroup> orderGroupList({required TableEntity table});
}

@LazySingleton(as: OrderCache)
class OrderCacheImpl implements OrderCache {
  final OrderRepository _repository;

  OrderCacheImpl(this._repository);

  StreamSubscription? _listener;
  final Map<TableEntity, List<OrderGroup>> _tableOrderGroupMap = {};

  @override
  void listenOnOrderUpdates(Restaurant restaurant) {
    _listener?.cancel();
    _listener = _repository.onOrderListUpdated(restaurant).listen((updateList) {
      for (final update in updateList) {
        _process(update);
      }
    });
  }

  @override
  Iterable<OrderGroup> orderGroupList({required TableEntity table}) =>
      _tableOrderGroupMap[table] ?? [];

  @override
  FutureOr onDispose() {
    _listener?.cancel();
  }

  void _process(OrderUpdate update) {
    final key = update.order.table;
    final order = update.order;
    switch (update.type) {
      case OrderUpdateType.added:
        _tableOrderGroupMap[key] ??= <OrderGroup>[];
        _tableOrderGroupMap[key]?.add(OrderGroup([order]));
        break;
      case OrderUpdateType.modified:
        _tableOrderGroupMap.groupForOrder(order)?.update(order);
        break;
      case OrderUpdateType.removed:
        final group = _tableOrderGroupMap.groupForOrder(order);
        if (group == null) break;
        group.remove(order);
        if (group.orderList.isEmpty) _tableOrderGroupMap[key]?.remove(group);
        break;
    }
    dev.log('Processed $update');
  }
}

extension on OrderGroup {
  bool contains(Order order) => orderList.contains(order);

  void remove(Order order) {
    orderList.remove(order);
    _sortOrders();
  }

  void update(Order order) {
    orderList.remove(order);
    orderList.add(order);
    _sortOrders();
  }

  void _sortOrders() {
    orderList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }
}

extension on Map<TableEntity, List<OrderGroup>> {
  OrderGroup? groupForOrder(Order order) {
    return this[order.table]?.firstWhereOrNull((e) => e.contains(order));
  }
}
