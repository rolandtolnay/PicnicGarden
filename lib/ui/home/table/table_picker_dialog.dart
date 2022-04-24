import 'package:flutter/material.dart' hide Table;
import 'package:provider/provider.dart';

import '../../../domain/model/table_entity.dart';
import '../topic/notification_provider.dart';
import '../../order/order_provider.dart';
import '../../common/dialog_title.dart';
import '../../common/list_item_widget.dart';

class TablePickerDialog extends StatelessWidget {
  final List<TableEntity> tables;
  final TableEntity? selectedTable;

  const TablePickerDialog(this.tables, {this.selectedTable, Key? key})
      : super(key: key);

  static Future<TableEntity?> show(
    BuildContext context, {
    required List<TableEntity> tableList,
    TableEntity? selectedTable,
  }) {
    return showDialog<TableEntity?>(
      context: context,
      builder: (_) => context.buildTablePicker(
        tableList: tableList,
        selectedTable: selectedTable,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    final orderProvider = context.watch<OrderProvider>();

    return AlertDialog(
      elevation: 2,
      title: const DialogTitle(text: 'Choose table', icon: Icons.tab),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: tables
              .map((table) => ListItemWidget(
                    table.name,
                    isSelected: table == selectedTable,
                    isMarked: orderProvider.ordersForTable(table).isNotEmpty,
                    badgeCount: notificationProvider
                        .notificationsForTable(table)
                        .length,
                    onTapped: () => Navigator.of(context).pop(table),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

extension on BuildContext {
  Widget buildTablePicker({
    required List<TableEntity> tableList,
    TableEntity? selectedTable,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: read<NotificationProvider>()),
        ChangeNotifierProvider.value(value: read<OrderProvider>()),
      ],
      child: TablePickerDialog(tableList, selectedTable: selectedTable),
    );
  }
}
