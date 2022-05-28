import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/table_entity.dart';
import '../../../order/order_provider.dart';
import '../table_status_picker_sheet.dart';
import 'table_status_ui_ext.dart';

class TableActionBar extends StatelessWidget {
  final TableEntity table;

  const TableActionBar({required this.table, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: 44,
      color: table.status?.backgroundColor ?? colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TableActionButton(
            icon: table.status.icon,
            title: table.status.title,
            onTap: () => TableStatusPickerSheet.show(context, table: table),
          ),
          TableActionButton(
            icon: Icons.workspaces,
            title: 'GROUP ORDERS',
            onTap: () {
              context.read<OrderProvider>().groupSimilarOrders(table);
            },
          )
        ],
      ),
    );
  }
}

class TableActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const TableActionButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.onPrimary, size: 16),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: textTheme.bodyText2?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
