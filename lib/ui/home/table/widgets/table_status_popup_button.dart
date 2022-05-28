import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/table_entity.dart';
import '../../../../domain/model/table_status.dart';
import '../table_provider.dart';
import '../table_status_provider.dart';
import 'table_status_ui_ext.dart';

class TableStatusPopupButton extends StatelessWidget {
  final TableEntity table;

  const TableStatusPopupButton({required this.table, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TableStatusProvider>();
    if (provider.isLoading) return SizedBox.shrink();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final menuButton = PopupMenuButton<TableStatus?>(
      tooltip: '',
      offset: const Offset(16, 28),
      child: Row(
        children: [
          Icon(table.status.icon, color: colorScheme.onPrimary, size: 20),
          const SizedBox(width: 8.0),
          Text(
            table.status.title,
            style: textTheme.bodyText2?.copyWith(color: colorScheme.onPrimary),
          ),
        ],
      ),
      itemBuilder: (context) => [
        ...provider.tableStatusList.map((e) => _buildStatusTile(e, context)),
        _buildClearTile(context),
      ],
    );
    final hideTooltipTheme = Theme.of(context).copyWith(
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: Colors.transparent),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Theme(data: hideTooltipTheme, child: menuButton),
      ),
    );
  }

  PopupMenuItem<TableStatus?> _buildStatusTile(
    TableStatus status,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuItem(
      onTap: () => _setStatus(status, context),
      child: Row(
        children: [
          Visibility(
            visible: status == table.status,
            replacement: const SizedBox(width: 24),
            child: Icon(Icons.check, color: colorScheme.primary),
          ),
          const SizedBox(width: 4.0),
          Text(status.name)
        ],
      ),
    );
  }

  PopupMenuItem<TableStatus?> _buildClearTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuItem(
      onTap: () => _setStatus(null, context),
      child: Row(
        children: [
          Icon(Icons.clear, color: colorScheme.error),
          const SizedBox(width: 4.0),
          Text('Clear status')
        ],
      ),
    );
  }

  void _setStatus(TableStatus? status, BuildContext context) {
    context.read<TableProvider>().setTableStatus(status, table: table);
  }
}
