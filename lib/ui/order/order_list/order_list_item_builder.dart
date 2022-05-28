import 'package:flutter/material.dart';

import '../../../domain/model/order/order_group.dart';
import '../../../domain/model/phase.dart';
import 'order_list_order_item.dart';
import 'order_list_phase_item.dart';

abstract class OrderListItem<T> {
  Color? get backgroundColor;

  Widget buildContent(BuildContext context);
}

class OrderListItemBuilder {
  final Iterable<Phase> phaseList;
  final Iterable<OrderGroup> orderGroupList;

  final bool showTimer;
  final ValueChanged<OrderGroup>? onOrderTapped;

  OrderListItemBuilder({
    required this.phaseList,
    required this.orderGroupList,
    required this.showTimer,
    this.onOrderTapped,
  });

  List<OrderListItem> buildListItems() {
    final sortedPhases = List.from(phaseList);
    sortedPhases.sort((a, b) => a.number.compareTo(b.number));

    // Creates a map of phase id, and matching list of order groups
    final phaseGroupMap = orderGroupList.fold<Map<String, List<OrderGroup>>>({},
        (map, orderGroup) {
      final key = orderGroup.phase.id;
      map[key] ??= <OrderGroup>[];
      map[key]?.add(orderGroup);
      return map;
    });
    for (final orderGroupList in phaseGroupMap.values) {
      orderGroupList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return sortedPhases.fold([], (list, phase) {
      list.add(OrderListPhaseItem(phase));
      final items = phaseGroupMap[phase.id]?.map(
        (orderGroup) {
          return OrderListOrderItem(
            orderGroup,
            showTimer: showTimer,
            onTapped: onOrderTapped,
          );
        },
      );
      if (items != null) list.addAll(items);
      return list;
    });
  }
}
