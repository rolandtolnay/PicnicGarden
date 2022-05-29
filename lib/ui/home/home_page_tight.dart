import 'package:flutter/material.dart' hide Table;
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../domain/service_error.dart';
import '../common/empty_refreshable.dart';
import '../order/order_add/order_add_floating_button.dart';
import '../phase/phase_loader.dart';
import 'home_page_tight_app_bar.dart';
import 'table/table_picker_dialog.dart';
import 'table/table_provider.dart';
import 'table/widgets/table_action_bar.dart';

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

    SchedulerBinding.instance.addPostFrameCallback((_) {
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
        HomePageTightAppBar(
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
        TableActionBar(table: selectedTable),
        Expanded(child: PhaseLoader()),
      ],
    );
  }
}
