import 'package:flutter/material.dart' hide Table;
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../logic/pg_error.dart';
import '../../model/table_entity.dart';
import '../../provider/notification_provider.dart';
import '../../provider/order/order_provider.dart';
import '../../provider/table_provider.dart';
import '../common/empty_refreshable.dart';
import '../order/order_add/order_add_floating_button.dart';
import '../phase/phase_loader.dart';
import 'widgets/home_page_app_bar.dart';
import 'widgets/table_picker_dialog.dart';

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

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    if (provider.isLoading || provider.selectedTable == null) {
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
          provider.selectedTable!,
          onTableTapped: () async {
            final selectedTable = await _tableFromDialog(context);
            if (selectedTable != null) {
              provider.selectTable(selectedTable);
            }
          },
        ),
        Expanded(child: PhaseLoader()),
      ],
    );
  }

  Future<TableEntity?> _tableFromDialog(BuildContext context) async {
    final provider = context.read<TableProvider>();
    return showDialog<TableEntity?>(
      context: context,
      builder: (_) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: context.read<NotificationProvider>(),
            ),
            ChangeNotifierProvider.value(
              value: context.read<OrderProvider>(),
            ),
          ],
          child: TablePickerDialog(
            provider.tables,
            selectedTable: provider.selectedTable,
          ),
        );
      },
    );
  }
}
