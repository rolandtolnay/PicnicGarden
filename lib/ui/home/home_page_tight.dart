import 'package:flutter/material.dart' hide Table;
import 'package:flutter/scheduler.dart';
import 'package:picnicgarden/ui/home/table/table_status_picker.dart';
import 'package:provider/provider.dart';

import '../../domain/model/table_entity.dart';
import '../../domain/pg_error.dart';
import '../common/empty_refreshable.dart';
import '../order/order_add/order_add_floating_button.dart';
import '../phase/phase_loader.dart';
import 'home_page_app_bar.dart';
import 'table/table_picker_dialog.dart';
import 'table/table_provider.dart';

class HomePageTight extends StatelessWidget {
  const HomePageTight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: _HomePageTightBody(),
        floatingActionButton: OrderAddFloatingButton(),
      ),
    );
  }
}

class _HomePageTightBody extends StatelessWidget {
  const _HomePageTightBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TableProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    final selectedTable = provider.selectedTable;
    if (provider.isLoading || selectedTable == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.tables.isEmpty) {
      return EmptyRefreshable(
        'No tables found.',
        onRefresh: provider.fetchTables,
      );
    }

    return Column(
      children: [
        HomePageAppBar(
          selectedTable,
          onTableTapped: () async {
            final table = await TablePickerDialog.show(
              context,
              tableList: provider.tables,
              selectedTable: selectedTable,
            );
            if (table != null) provider.selectTable(table);
          },
        ),
        Divider(height: 0, color: colorScheme.primaryContainer),
        TableStatusPickerBar(table: selectedTable),
        Expanded(child: PhaseLoader()),
      ],
    );
  }
}

class TableStatusPickerBar extends StatelessWidget {
  final TableEntity table;

  const TableStatusPickerBar({required this.table, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () => TableStatusPicker.show(context, table: table),
      child: Container(
        height: 44,
        color: colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.threesixty, color: colorScheme.onPrimary),
            SizedBox(width: 8.0),
            Text(
              'SET TABLE STATUS',
              style: textTheme.caption?.copyWith(color: colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
