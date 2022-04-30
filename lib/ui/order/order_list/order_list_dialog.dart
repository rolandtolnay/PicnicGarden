import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/table_entity.dart';
import '../../common/common_dialog.dart';
import '../../home/table/table_filter_provider.dart';
import '../../home/table/table_name_widget.dart';
import '../../home/table/table_provider.dart';
import '../../phase/phase_provider.dart';
import '../../recipe/recipe_provider.dart';
import '../order_add/order_add_floating_button.dart';
import '../order_provider.dart';
import 'order_list_page.dart';
import 'order_status_provider.dart';

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
    return CommonDialog(
      padding: EdgeInsets.zero,
      child: Scaffold(
        floatingActionButton: OrderAddFloatingButton(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
        ChangeNotifierProvider.value(value: read<RecipeProvider>()),
        ChangeNotifierProvider.value(value: read<TableFilterProvider>())
      ],
      child: OrderListDialog(table: table),
    );
  }
}
