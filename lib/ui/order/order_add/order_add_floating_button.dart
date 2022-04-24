import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/order/order_status_provider.dart';
import '../../../provider/table_provider.dart';
import 'order_add_dialog.dart';

class OrderAddFloatingButton extends StatelessWidget {
  const OrderAddFloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tablePvd = context.watch<TableProvider>();
    final oStatusPvd = context.watch<OrderStatusProvider>();
    if (tablePvd.isLoading ||
        tablePvd.selectedTable == null ||
        oStatusPvd.isLoading ||
        oStatusPvd.orderStatusList.isEmpty) {
      return Container();
    }

    final table = tablePvd.selectedTable!;
    return FloatingActionButton(
      onPressed: () => context.showOrderAddDialog(table: table),
      child: const Icon(Icons.add),
    );
  }
}
