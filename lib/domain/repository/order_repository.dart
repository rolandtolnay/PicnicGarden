import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:injectable/injectable.dart';

import '../compact_map.dart';
import '../model/order/order.dart';
import '../model/order/order_status.dart';
import '../model/order/order_update.dart';
import '../model/restaurant.dart';
import '../service_error.dart';
import 'api_client.dart';
import 'connectivity_checker.dart';
import 'fir_collection_reference.dart';

abstract class OrderRepository {
  Stream<Iterable<OrderUpdate>> onOrderListUpdated(Restaurant restaurant);

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
  Stream<Iterable<OrderUpdate>> onOrderListUpdated(Restaurant restaurant) =>
      _ref
          .orders(restaurant)
          .whereDelivered(isNull: true)
          .snapshots()
          .map((e) => e.docChanges.compactMap(OrderUpdateFactory.from));

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
    final updated = order.moveToNextFlow(orderStatusList: orderStatusList);
    return commitOrder(updated, restaurant: restaurant);
  }
}

extension OrderUpdateFactory on OrderUpdate {
  static OrderUpdate? from(
      FirestoreDocumentChange<OrderDocumentSnapshot> snapshot) {
    final data = snapshot.doc.data;
    if (data == null) return null;
    switch (snapshot.type) {
      case DocumentChangeType.added:
        return OrderUpdate.added(data);
      case DocumentChangeType.removed:
        return OrderUpdate.removed(data);
      case DocumentChangeType.modified:
        return OrderUpdate.modified(data);
    }
  }
}
