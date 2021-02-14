import 'dart:collection';

import 'package:meta/meta.dart';

import '../logic/pg_error.dart';
import '../model/order.dart';
import '../model/order_status.dart';
import 'entity_provider.dart';

abstract class OrderProvider extends EntityProvider {
  UnmodifiableListView<Order> get orders;

  Future fetchOrders();

  Future<PGError> commitOrder(Order order);
  Future<PGError> commitNextFlow({
    @required Order order,
    @required List<OrderStatus> orderStatusList,
  });
}

class FIROrderProvider extends FIREntityProvider<Order>
    implements OrderProvider {
  FIROrderProvider() : super('orders', (json) => Order.fromJson(json));

  @override
  UnmodifiableListView<Order> get orders => UnmodifiableListView(entities);

  @override
  Future fetchOrders() async {
    await fetchEntities();
  }

  @override
  Future<PGError> commitOrder(Order order) {
    return putEntity(order.id, order.toJson());
  }

  @override
  Future<PGError> commitNextFlow({
    Order order,
    List<OrderStatus> orderStatusList,
  }) {
    final currentFlow = order.currentStatus.flow;
    final nextFlow = currentFlow + 1;
    if (nextFlow < orderStatusList.length) {
      // Update flow
      var lastFlowEndDate = order.created;
      final previousFlow = currentFlow - 1;
      if (previousFlow >= 0) {
        lastFlowEndDate = order.created.add(order.flow.values.reduce(
            (value, element) =>
                Duration(seconds: value.inSeconds + element.inSeconds)));
      }
      order.flow[order.currentStatus.name] = Duration(
        seconds: DateTime.now().difference(lastFlowEndDate).inSeconds,
      );
      // Update current status
      final nextStatus = orderStatusList[nextFlow];
      order.currentStatus = nextStatus;
      // Update delivered
      if (nextFlow == orderStatusList.length - 1) {
        order.delivered = DateTime.now();
      }
      return commitOrder(order);
    } else {
      return Future.value(null);
    }
  }
}
