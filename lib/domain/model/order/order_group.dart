import '../phase.dart';
import '../recipe.dart';
import 'order.dart';
import 'order_status.dart';

class OrderGroup {
  final List<Order> orderList;

  OrderGroup(this.orderList) : assert(orderList.isNotEmpty);

  Order get _alphaOrder => orderList.first;

  Phase get phase => _alphaOrder.phase;
  DateTime get createdAt => _alphaOrder.createdAt;
  String get colorHex => _alphaOrder.currentStatus.colorHex;
  Recipe get recipe => _alphaOrder.recipe;
  String? get customNote => _alphaOrder.customNote;
  OrderStatus get currentStatus => _alphaOrder.currentStatus;
  Duration get currentDuration => _alphaOrder.currentDuration;

  bool get shouldNotifyStatus {
    final attributeIds = recipe.attributes.map((a) => a.id);
    final notifyAttributeIds =
        currentStatus.notifyTopics.values.expand((e) => e);
    return attributeIds.any(notifyAttributeIds.contains);
  }
}
