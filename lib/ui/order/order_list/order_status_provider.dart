import 'dart:collection';

import 'package:injectable/injectable.dart';

import '../../../domain/model/order/order_status.dart';
import '../../entity_provider.dart';
import '../../restaurant/restaurant_provider.dart';

abstract class OrderStatusProvider extends EntityProvider {
  UnmodifiableListView<OrderStatus> get orderStatusList;

  Future fetchOrderStatusList();
}

@Injectable(as: OrderStatusProvider)
class FIROrderStatusProvider extends FIREntityProvider<OrderStatus>
    implements OrderStatusProvider {
  FIROrderStatusProvider({
    required RestaurantProvider restaurantProvider,
  }) : super(
          'orderStatus',
          OrderStatus.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        ) {
    fetchOrderStatusList();
  }

  @override
  UnmodifiableListView<OrderStatus> get orderStatusList =>
      UnmodifiableListView(entities);

  @override
  Future fetchOrderStatusList() async {
    await fetchEntities();
    entities.sort((a, b) => a.flow.compareTo(b.flow));
  }
}
