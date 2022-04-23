import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../logic/pg_error.dart';
import '../../../model/order.dart';
import '../../../provider/di.dart';
import '../../../provider/order/order_builder.dart';
import '../../../provider/order/order_provider.dart';
import '../../../provider/order/order_status_provider.dart';
import '../../../provider/phase_provider.dart';
import '../../../provider/recipe_provider.dart';
import '../../../provider/table_provider.dart';
import '../../common/snackbar_builder.dart';
import 'order_add_dialog.dart';

class OrderAddButton extends StatelessWidget {
  const OrderAddButton({Key? key}) : super(key: key);

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

    return FloatingActionButton(
      onPressed: () => _presentOrderAddDialog(context),
      child: const Icon(Icons.add),
    );
  }

  void _presentOrderAddDialog(BuildContext context) {
    final tableProvider = context.read<TableProvider>();
    final orderStatusProvider = context.read<OrderStatusProvider>();

    showDialog(
      context: context,
      builder: (_) {
        return Provider(
          create: (_) => di<OrderBuilder>()
            ..setTable(tableProvider.selectedTable!)
            ..setOrderStatus(orderStatusProvider.orderStatusList.first),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: context.read<RecipeProvider>(),
              ),
              ChangeNotifierProvider.value(
                value: context.read<PhaseProvider>(),
              ),
              ChangeNotifierProvider.value(
                value: context.read<OrderProvider>(),
              )
            ],
            child: OrderAddDialog(
              onOrderCreated: (o) => _onOrderCreated(o, context),
            ),
          ),
        );
      },
    );
  }

  void _onOrderCreated(Order order, BuildContext context) async {
    final error = await context.read<OrderProvider>().commitOrder(order);
    if (error != null) return error.showInDialog(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarBuilder.orderSucces(order, context),
    );
  }
}
