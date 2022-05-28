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

  void groupSimilarOrders(TableEntity table);
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
  void groupSimilarOrders(TableEntity table) {
    final map = _tableOrderGroupMap[table];
    if (map == null || map.isEmpty) return;

    _tableOrderGroupMap[table] = map.fold<List<OrderGroup>>(
      [],
      (result, group) {
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
          existing.orderList.addAll(group.orderList);
        }
        return result;
      },
    );
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
