import 'package:flutter/material.dart' hide Table;
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../logic/pg_error.dart';
import '../../provider/notification_provider.dart';
import '../../provider/table_provider.dart';
import '../common/empty_refreshable.dart';
import '../order/add_order.dart';
import '../order/phase_loader.dart';
import 'home_page_app_bar.dart';
import 'table_picker_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: _HomePageBody(),
          floatingActionButton: AddOrderButton(),
        ),
      ),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TableProvider>();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    if (provider.isLoading) {
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
          provider.selectedTable,
          onTableTapped: () async {
            final selectedTable = await showDialog(
              context: context,
              builder: (_) => ChangeNotifierProvider.value(
                value: context.read<NotificationProvider>(),
                child: TablePickerDialog(
                  provider.tables,
                  selectedTable: provider.selectedTable,
                ),
              ),
            );
            if (selectedTable != null) {
              provider.selectTable(selectedTable);
            }
          },
        ),
        Expanded(child: PhaseLoader()),
      ],
    );
  }
}
