import 'dart:collection';

import 'package:flutter/material.dart' hide Table;
import 'package:provider/provider.dart';

import '../../model/table_entity.dart';
import '../../provider/notification_provider.dart';
import '../../provider/order/order_provider.dart';
import '../common/list_item_widget.dart';
import '../common/dialog_title.dart';

class TablePickerDialog extends StatelessWidget {
  const TablePickerDialog(this.tables, {this.selectedTable, Key? key})
      : super(key: key);

  final UnmodifiableListView<TableEntity> tables;
  final TableEntity? selectedTable;

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
