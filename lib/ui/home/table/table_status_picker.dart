import 'package:flutter/material.dart';
import 'package:picnicgarden/domain/model/table_status.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/table_entity.dart';
import '../../../injection.dart';
import 'table_provider.dart';
import 'table_status_provider.dart';

class TableStatusPicker extends StatelessWidget {
  final TableEntity table;

  const TableStatusPicker._({Key? key, required this.table}) : super(key: key);

  static void show(BuildContext context, {required TableEntity table}) {
    showModalBottomSheet(
      context: context,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: context.read<TableProvider>()),
          ChangeNotifierProvider(create: (_) => di<TableStatusProvider>()),
        ],
        child: TableStatusPicker._(table: table),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TableStatusProvider>();
    if (provider.isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Wrap(
      children: [
        ...provider.tableStatusList.map((e) => _buildStatusTile(e, context)),
        Divider(),
        _buildClearTile(context)
      ],
    );
  }

  ListTile _buildStatusTile(TableStatus status, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Visibility(
        visible: status == table.status,
        child: Icon(Icons.check, color: colorScheme.primary),
      ),
      title: Text(status.name),
      onTap: () => _setStatusAndPop(status, context),
    );
  }

  ListTile _buildClearTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.clear, color: colorScheme.error),
      title: Text('Clear status'),
      onTap: () => _setStatusAndPop(null, context),
    );
  }

  void _setStatusAndPop(TableStatus? status, BuildContext context) {
    context.read<TableProvider>().setTableStatus(status, table: table);
    Navigator.of(context).pop();
  }
}
