import 'package:flutter/material.dart';

import '../../../domain/model/order.dart';
import '../../../domain/model/phase.dart';
import 'order_list_order_item.dart';
import 'order_list_phase_item.dart';

abstract class OrderListItem<T> {
  Color? get backgroundColor;

  Widget buildContent(BuildContext context);
}

class OrderListItemBuilder {
  final Iterable<Phase> phases;
  final Iterable<Order> orders;

  final bool showTimer;
  final ValueChanged<Order>? onOrderTapped;

  OrderListItemBuilder({
    required this.phases,
    required this.orders,
    required this.showTimer,
    this.onOrderTapped,
  });

  List<OrderListItem> buildListItems() {
    final sortedPhases = List.from(phases);
    sortedPhases.sort((a, b) => a.number.compareTo(b.number));

    // Creates a map of phase id, and matching list of orders
    // ignore: omit_local_variable_types
    final Map<String, List<Order>> phaseMap =
        orders.fold(<String, List<Order>>{}, (map, order) {
      final phaseKey = order.phase.id;
      if (map[phaseKey] == null) {
        map[phaseKey] = [order];
      } else {
        map[phaseKey]!.add(order);
      }
      return map;
    });
    for (var orderList in phaseMap.values) {
      orderList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return sortedPhases.fold(<OrderListItem>[], (list, phase) {
      list.add(OrderListPhaseItem(phase));
      if (phaseMap[phase.id] != null) {
        list.addAll(
          phaseMap[phase.id]!.map(
            (order) => OrderListOrderItem(
              order,
              showTimer: showTimer,
              onTapped: onOrderTapped,
            ),
          ),
        );
      }
      return list;
    });
  }
}
