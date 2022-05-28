import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:picnicgarden/domain/model/restaurant.dart';
import 'package:picnicgarden/domain/model/table_entity.dart';

import '../model/order.dart';
import '../repository/order_repository.dart';

import 'dart:developer' as dev;

abstract class OrderCache {
  void listenOnOrderUpdates(Restaurant restaurant);

  Iterable<Order> ordersForTable(TableEntity table);
}

@LazySingleton(as: OrderCache)
class OrderCacheImpl implements OrderCache {
  final OrderRepository _repository;

  OrderCacheImpl(this._repository);

  StreamSubscription? _listener;
  Map<TableEntity, List<Order>> _tableOrderMap = {};

  @override
  void listenOnOrderUpdates(Restaurant restaurant) {
    _listener?.cancel();
    _listener = _repository.onOrderListUpdated(restaurant).listen((orderList) {
      _tableOrderMap = orderList.fold({}, (map, order) {
        final key = order.table;
        map[key] ??= <Order>[];
        map[key]?.add(order);
        return map;
      });
      dev.log('Received $Order snapshot with ${orderList.length} entities.');
    });
  }

  @override
  Iterable<Order> ordersForTable(TableEntity table) =>
      _tableOrderMap[table] ?? [];
}
