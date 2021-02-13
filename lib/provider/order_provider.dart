import 'dart:collection';

import '../model/order.dart';
import 'entity_provider.dart';

abstract class OrderProvider extends EntityProvider {
  UnmodifiableListView<Order> get orders;

  Future fetchOrders();
}

class FIROrderProvider extends FIREntityProvider<Order>
    implements OrderProvider {
  FIROrderProvider() : super('orders', (json) => Order.fromJson(json));

  @override
  UnmodifiableListView<Order> get orders => super.entities;

  @override
  Future fetchOrders() async {
    await super.fetchEntities();
  }
}
