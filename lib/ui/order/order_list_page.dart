import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../logic/pg_error.dart';
import '../../model/order.dart';
import '../../model/phase.dart';
import '../../provider/order/order_provider.dart';
import '../../provider/order/order_status_provider.dart';
import '../../provider/phase_provider.dart';
import '../../provider/table_provider.dart';
import 'order_list.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final phases = context.watch<PhaseProvider>().phases;
    final orderStatusList =
        context.watch<OrderStatusProvider>().orderStatusList;

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedTable = context.watch<TableProvider>().selectedTable;
    final builder = ItemBuilder(
      orders: provider.ordersForTable(selectedTable!),
      phases: phases,
    );
    return OrderList(
      builder.buildListItems(),
      onOrderTapped: (order) async {
        final provider = context.read<OrderProvider>();
        final error = await provider.commitNextFlow(
          order: order,
          orderStatusList: orderStatusList,
        );
        error?.showInDialog(context);
      },
    );
  }
}

abstract class ListItem<T> {
  Color? get backgroundColor;

  Widget buildContent(BuildContext context);
}

class ItemBuilder {
  final List<Phase>? phases;
  final List<Order>? orders;

  ItemBuilder({this.phases, this.orders});

  List<ListItem> buildListItems() {
    final sortedPhases = List.from(phases!);
    sortedPhases.sort((a, b) => a.number.compareTo(b.number));

    // ignore: omit_local_variable_types
    final Map<String, List<Order>> phaseMap =
        orders!.fold(<String, List<Order>>{}, (map, order) {
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

    return sortedPhases.fold(<ListItem>[], (list, phase) {
      list.add(PhaseItem(phase));
      if (phaseMap[phase.id] != null) {
        list.addAll(
          phaseMap[phase.id]!.map(
            OrderItem.new,
          ),
        );
      }
      return list;
    });
  }
}
