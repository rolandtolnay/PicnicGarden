import 'dart:async';
import 'dart:collection';

import '../../domain/api_response.dart';
import '../../domain/model/attribute.dart';
import '../../domain/pg_error.dart';
import '../../domain/model/order.dart';
import '../../domain/model/order_status.dart';
import '../../domain/model/table_entity.dart';
import '../entity_provider.dart';
import '../home/topic/notification_provider.dart';
import '../restaurant/restaurant_provider.dart';

abstract class OrderProvider extends EntityProvider {
  UnmodifiableListView<Order> ordersForTable(TableEntity table);

  Future<PGError?> commitOrder(Order order);
  Future<PGError?> commitNextFlow({
    required Order order,
    required List<OrderStatus> orderStatusList,
  });
}

class FIROrderProvider extends FIREntityProvider<Order>
    implements OrderProvider {
  final NotificationProvider _notificationProvider;

  FIROrderProvider({
    required NotificationProvider notificationProvider,
    required RestaurantProvider restaurantProvider,
  })  : _notificationProvider = notificationProvider,
        super(
          'orders',
          Order.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        ) {
    response = ApiResponse.loading();
    listenOnSnapshots(query: collection.where('delivered', isNull: true));
  }

  @override
  UnmodifiableListView<Order> ordersForTable(TableEntity table) =>
      UnmodifiableListView(
        entities.where((order) => order.table == table),
      );

  @override
  Future<PGError?> commitOrder(Order order) async {
    final error = await postEntity(order.id, order.toJson());
    if (order.shouldNotifyStatus) {
      return _notificationProvider.postNotificationForOrder(order);
    }
    return error;
  }

  @override
  Future<PGError?> commitNextFlow({
    required Order order,
    required List<OrderStatus> orderStatusList,
  }) {
    final currentFlow = order.currentStatus.flow;
    final nextFlow = currentFlow + 1;
    if (nextFlow < orderStatusList.length) {
      // Update flow
      var lastFlowEndDate = order.createdAt;
      final previousFlow = currentFlow - 1;
      if (previousFlow >= 0) {
        lastFlowEndDate = order.createdAt.add(order.flow.values.reduce(
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

extension OrderListFilter on Iterable<Order> {
  Iterable<Order> filteredBy({required Iterable<Attribute> enabledAttributes}) {
    return where((o) => o.recipe.attributes.containsAnyFrom(enabledAttributes));
  }
}

extension on Iterable {
  bool containsAnyFrom(Iterable other) {
    return toSet().intersection(other.toSet()).isNotEmpty;
  }
}
