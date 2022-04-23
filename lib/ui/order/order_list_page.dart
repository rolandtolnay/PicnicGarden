import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../logic/pg_error.dart';

import '../../model/table_entity.dart';
import '../../provider/order/order_provider.dart';
import '../../provider/order/order_status_provider.dart';
import '../../provider/phase_provider.dart';

import 'items/order_list_item_builder.dart';
import 'order_list.dart';

class OrderListPage extends StatelessWidget {
  final TableEntity table;
  final bool showTimer;

  const OrderListPage({Key? key, required this.table, required this.showTimer})
      : super(key: key);

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

    final builder = OrderListItemBuilder(
      orders: provider.ordersForTable(table),
      phases: phases,
      showTimer: showTimer,
      onOrderTapped: (order) async {
        final provider = context.read<OrderProvider>();
        final error = await provider.commitNextFlow(
          order: order,
          orderStatusList: orderStatusList,
        );
        error?.showInDialog(context);
      },
    );
    return OrderList(
      items: builder.buildListItems(),
      showTimer: showTimer,
    );
  }
}
