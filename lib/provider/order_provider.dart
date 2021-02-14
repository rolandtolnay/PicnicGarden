import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../logic/pg_error.dart';
import '../model/order.dart';
import '../model/order_status.dart';
import '../model/table.dart';
import 'entity_provider.dart';

abstract class OrderProvider extends EntityProvider {
  Stream<UnmodifiableListView<Order>> orderStreamForTable(Table table);

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
  Stream<UnmodifiableListView<Order>> orderStreamForTable(Table table) =>
      collection
          .where('delivered', isNull: true)
          .where('table.id', isEqualTo: table.id)
          .snapshots()
          .map((snap) => UnmodifiableListView(
                snap.docs.map(_Order.fromDoc).toList(),
              ));

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

extension _Order on Order {
  static Order fromDoc(DocumentSnapshot doc) => Order.fromJson(doc.data());
}
