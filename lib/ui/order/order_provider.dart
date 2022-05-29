import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/cache/order_cache.dart';
import '../../domain/model/attribute.dart';
import '../../domain/model/order/order.dart';
import '../../domain/model/order/order_group.dart';
import '../../domain/model/order/order_status.dart';
import '../../domain/model/restaurant.dart';
import '../../domain/model/table_entity.dart';
import '../../domain/repository/order_repository.dart';
import '../common/api_responder.dart';
import '../common/api_response.dart';
import '../home/topic/notification_provider.dart';
import '../restaurant/restaurant_provider.dart';

abstract class OrderProvider extends ChangeNotifier with ApiResponder {
  Iterable<OrderGroup> orderGroupList({required TableEntity table});

  Future<void> commitOrder(Order order);

  Future<void> commitNextFlow({
    required OrderGroup orderGroup,
    required List<OrderStatus> orderStatusList,
  });

  Future<void> groupSimilarOrders(
    TableEntity table, {
    Duration interval = const Duration(minutes: 7),
    Future<bool> Function(Duration)? shouldGroupBeyondInterval,
  });
}

@Injectable(as: OrderProvider)
class FIROrderProvider extends ChangeNotifier
    with ApiResponder
    implements OrderProvider {
  final NotificationProvider _notificationProvider;
  final OrderRepository _repository;
  final OrderCache _cache;
  final Restaurant _restaurant;

  FIROrderProvider(
    this._repository,
    this._cache,
    this._notificationProvider, {
    required RestaurantProvider restaurantProvider,
  }) : _restaurant = restaurantProvider.selectedRestaurant!;

  ApiResponse _response = ApiResponse.initial();

  @override
  ApiResponse get response => _response;

  @override
  Iterable<OrderGroup> orderGroupList({required TableEntity table}) =>
      _cache.orderGroupList(table: table);

  @override
  Future<void> commitOrder(Order order) async {
    _response = ApiResponse.loading();
    notifyListeners();

    var error = await _repository.commitOrderGroup(
      OrderGroup([order]),
      restaurant: _restaurant,
    );

    if (error == null && order.shouldNotifyStatus) {
      error = await _notificationProvider.postForOrder(order);
    }

    _response = ApiResponse.fromErrorResult(error);
    notifyListeners();
  }

  @override
  Future<void> commitNextFlow({
    required OrderGroup orderGroup,
    required List<OrderStatus> orderStatusList,
  }) async {
    final error = await _repository.commitNextFlow(
      orderGroup,
      orderStatusList: orderStatusList,
      restaurant: _restaurant,
    );

    _response = ApiResponse.fromErrorResult(error);
    notifyListeners();
  }

  @override
  Future<void> groupSimilarOrders(
    TableEntity table, {
    Duration interval = const Duration(minutes: 7),
    Future<bool> Function(Duration)? shouldGroupBeyondInterval,
  }) async {
    await _cache.groupSimilarOrders(
      table,
      interval: interval,
      shouldGroupBeyondInterval: shouldGroupBeyondInterval,
    );
    notifyListeners();
  }
}

extension OrderGroupListFilter on Iterable<OrderGroup> {
  Iterable<OrderGroup> filteredBy({
    required Iterable<Attribute> enabledAttributes,
  }) {
    return where((e) => e.recipe.attributes.containsAnyFrom(enabledAttributes));
  }
}

extension on Iterable {
  bool containsAnyFrom(Iterable other) {
    return toSet().intersection(other.toSet()).isNotEmpty;
  }
}
