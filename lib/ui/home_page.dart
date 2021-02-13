import 'package:flutter/material.dart' hide Table;
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../logic/pg_error.dart';
import '../provider/table_provider.dart';
import 'phase_loader.dart';
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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              print('Add order tapped');
            },
          ),
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
      return RefreshIndicator(
        onRefresh: provider.fetchTables,
        child: Stack(
          children: [
            ListView(),
            Center(
                child: Text('No tables found.',
                    style: Theme.of(context).textTheme.subtitle1)),
          ],
        ),
      );
    }

    return Column(
      children: [
        _AppBar(
          provider.selectedTable.name,
          onTapped: () async {
            final selectedTable = await showDialog(
              context: context,
              builder: (_) => TablePickerDialog(
                provider.tables,
                selectedTable: provider.selectedTable,
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

class _AppBar extends StatelessWidget {
  const _AppBar(
    this.selectedTableName, {
    this.onTapped,
    Key key,
  }) : super(key: key);

  final String selectedTableName;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;

    return InkWell(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tab, size: 24, color: textColor),
            const SizedBox(width: 8.0),
            Text(selectedTableName,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: textColor)),
            const SizedBox(width: 16.0),
          ],
        ),
      ),
      onTap: () => onTapped?.call(),
    );
  }
}
