import 'package:injectable/injectable.dart';
import '../model/restaurant.dart';

import '../model/order.dart';
import 'fir_collection_reference.dart';

abstract class OrderRepository {
  Stream<Iterable<Order>> onOrderListUpdated(Restaurant restaurant);
}

@LazySingleton(as: OrderRepository)
class FirOrderRepository implements OrderRepository {
  final FirCollectionReference _ref;

  FirOrderRepository(this._ref);

  @override
  Stream<Iterable<Order>> onOrderListUpdated(Restaurant restaurant) => _ref
      .orders(restaurant.name)
      .whereDelivered(isNull: true)
      .snapshots()
      .map((e) => e.docs.map((e) => e.data));
}
