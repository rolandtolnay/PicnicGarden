import 'package:flutter/material.dart';
import 'package:picnicgarden/model/table_entity.dart';
import 'package:provider/provider.dart';

import '../../../provider/order/order_provider.dart';
import '../../../provider/order/order_status_provider.dart';
import '../../../provider/phase_provider.dart';
import '../../../provider/recipe_provider.dart';
import '../../../provider/table_provider.dart';
import '../../common/max_width_container.dart';
import '../../home/widgets/table_name_widget.dart';
import '../order_add/order_add_floating_button.dart';
import 'order_list_page.dart';

class OrderListDialog extends StatelessWidget {
  final TableEntity table;

  const OrderListDialog({Key? key, required this.table}) : super(key: key);

  static void show(BuildContext context, {required TableEntity table}) {
    showDialog(
      context: context,
      builder: (_) => context.buildOrderListDialog(table: table),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: OrderAddFloatingButton(),
      body: Column(
        children: [
          Material(
            elevation: 4,
            color: colorScheme.primary,
            child: TableNameWidget(
              table: table,
              showNotifications: false,
            ),
          ),
          Expanded(
            child: OrderListPage(
              scrollable: true,
              showTimer: true,
              table: table,
            ),
          ),
        ],
      ),
    );
  }
}

extension on BuildContext {
  Widget buildOrderListDialog({required TableEntity table}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: read<OrderProvider>()),
        ChangeNotifierProvider.value(value: read<PhaseProvider>()),
        ChangeNotifierProvider.value(value: read<OrderStatusProvider>()),
        ChangeNotifierProvider.value(value: read<TableProvider>()),
        ChangeNotifierProvider.value(value: read<RecipeProvider>())
      ],
      child: MaxWidthContainer(
        child: Dialog(child: OrderListDialog(table: table)),
      ),
    );
  }
}
