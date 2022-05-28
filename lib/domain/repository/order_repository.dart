import 'package:injectable/injectable.dart';

import '../model/order.dart';
import '../model/order_status.dart';
import '../model/restaurant.dart';
import '../service_error.dart';
import 'api_client.dart';
import 'connectivity_checker.dart';
import 'fir_collection_reference.dart';

abstract class OrderRepository {
  Stream<Iterable<Order>> onOrderListUpdated(Restaurant restaurant);

  Future<ServiceError?> commitNextFlow(
    Order order, {
    required List<OrderStatus> orderStatusList,
    required Restaurant restaurant,
  });

  Future<ServiceError?> commitOrder(
    Order order, {
    required Restaurant restaurant,
  });
}

@LazySingleton(as: OrderRepository)
class FirOrderRepository with ConnectivityChecker implements OrderRepository {
  final FirCollectionReference _ref;
  final ApiClient _client;

  FirOrderRepository(this._ref, this._client);

  @override
  Stream<Iterable<Order>> onOrderListUpdated(Restaurant restaurant) => _ref
      .orders(restaurant)
      .whereDelivered(isNull: true)
      .snapshots()
      .map((e) => e.docs.map((e) => e.data));

  @override
  Future<ServiceError?> commitOrder(
    Order order, {
    required Restaurant restaurant,
  }) {
    return _client.execute(
      () => _ref.orders(restaurant).doc(order.id).set(order),
    );
  }

  @override
  Future<ServiceError?> commitNextFlow(
    Order order, {
    required List<OrderStatus> orderStatusList,
    required Restaurant restaurant,
  }) {
    // TODO: Make Order immutable and extract below into factory constructor
    final currentFlow = order.currentStatus.flow;
    final nextFlow = currentFlow + 1;
    if (nextFlow >= orderStatusList.length) return Future.value(null);

    final now = DateTime.now();
    // Update flow
    var lastFlowEndDate = order.createdAt;
    final previousFlow = currentFlow - 1;
    if (previousFlow >= 0) {
      lastFlowEndDate = order.createdAt.add(
        order.flow.values.reduce(
          (value, element) =>
              Duration(seconds: value.inSeconds + element.inSeconds),
        ),
      );
    }
    order.flow[order.currentStatus.name] = Duration(
      seconds: now.difference(lastFlowEndDate).inSeconds,
    );
    // Update current status
    final nextStatus = orderStatusList[nextFlow];
    order.currentStatus = nextStatus;
    // Update delivered
    if (nextFlow == orderStatusList.length - 1) {
      order.delivered = now.toIso8601String();
    }
    return commitOrder(order, restaurant: restaurant);
  }
}
