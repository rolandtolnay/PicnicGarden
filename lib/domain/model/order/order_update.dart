import 'package:equatable/equatable.dart';

import 'order.dart';

class OrderUpdate extends Equatable {
  final Order order;
  final OrderUpdateType type;

  const OrderUpdate.added(this.order) : type = OrderUpdateType.added;
  const OrderUpdate.removed(this.order) : type = OrderUpdateType.removed;
  const OrderUpdate.modified(this.order) : type = OrderUpdateType.modified;

  @override
  List<Object?> get props => [order, type];

  @override
  bool? get stringify => true;
}

enum OrderUpdateType { added, removed, modified }
