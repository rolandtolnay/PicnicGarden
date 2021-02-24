import 'dart:collection';

import '../../model/order_status.dart';
import '../entity_provider.dart';

abstract class OrderStatusProvider extends EntityProvider {
  UnmodifiableListView<OrderStatus> get orderStatusList;

  Future fetchOrderStatusList();
}

class FIROrderStatusProvider extends FIREntityProvider<OrderStatus>
    implements OrderStatusProvider {
  FIROrderStatusProvider()
      : super('orderStatus', (json) => OrderStatus.fromJson(json));

  @override
  UnmodifiableListView<OrderStatus> get orderStatusList =>
      UnmodifiableListView(entities);

  @override
  Future fetchOrderStatusList() async {
    await fetchEntities();
    entities.sort((a, b) => a.flow.compareTo(b.flow));
  }
}
