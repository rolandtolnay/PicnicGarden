import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../order_list/order_status_provider.dart';
import '../../home/table/table_provider.dart';
import 'order_add_dialog.dart';

class OrderAddFloatingButton extends StatelessWidget {
  const OrderAddFloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableProvider = context.watch<TableProvider>();
    final oStatusProvider = context.watch<OrderStatusProvider>();
    if (tableProvider.isLoading ||
        tableProvider.selectedTable == null ||
        oStatusProvider.isLoading ||
        oStatusProvider.orderStatusList.isEmpty) {
      return Container();
    }

    final table = tableProvider.selectedTable!;
    return FloatingActionButton(
      onPressed: () => OrderAddDialog.show(context, table: table),
      child: const Icon(Icons.add),
    );
  }
}
