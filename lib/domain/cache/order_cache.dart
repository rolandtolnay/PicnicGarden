import 'dart:async';

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

  Iterable<Order> ordersForTable(TableEntity table);

  Iterable<OrderGroup> orderGroupList({required TableEntity table});
}

@LazySingleton(as: OrderCache)
class OrderCacheImpl implements OrderCache {
  final OrderRepository _repository;

  OrderCacheImpl(this._repository);

  StreamSubscription? _listener;
  final Map<TableEntity, List<Order>> _tableOrderMap = {};

  final Map<TableEntity, List<OrderGroup>> _tableOrderGroupMap = {};

  @override
  void listenOnOrderUpdates(Restaurant restaurant) {
    _listener?.cancel();
    _listener = _repository.onOrderListUpdated(restaurant).listen((updateList) {
      for (final update in updateList) {
        final key = update.order.table;
        final order = update.order;
        switch (update.type) {
          case OrderUpdateType.added:
            _tableOrderMap[key] ??= <Order>[];
            _tableOrderMap[key]?.add(order);

            _tableOrderGroupMap[key] ??= <OrderGroup>[];
            _tableOrderGroupMap[key]?.add(OrderGroup([order]));
            break;
          case OrderUpdateType.removed:
            _tableOrderMap[key]?.remove(order);

            final group =
                _tableOrderGroupMap[key]?.firstWhere((e) => e.contains(order));
            if (group != null) {
              group.remove(order);
              if (group.orderList.isEmpty) {
                _tableOrderGroupMap[key]?.remove(group);
              }
            }
            break;
          case OrderUpdateType.modified:
            _tableOrderMap[key]?.remove(order);
            _tableOrderMap[key]?.add(order);

            _tableOrderGroupMap[key]
                ?.firstWhere((e) => e.contains(order))
                .update(order);
            break;
        }
        dev.log('Processed $update');
      }
    });
  }

  @override
  Iterable<Order> ordersForTable(TableEntity table) =>
      _tableOrderMap[table] ?? [];

  @override
  Iterable<OrderGroup> orderGroupList({required TableEntity table}) =>
      _tableOrderGroupMap[table] ?? [];

  @override
  FutureOr onDispose() {
    _listener?.cancel();
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
