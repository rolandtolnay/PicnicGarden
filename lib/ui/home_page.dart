import 'package:flutter/material.dart' hide Table;
import 'package:flutter/scheduler.dart';
import 'package:picnicgarden/provider/providers.dart';
import 'package:picnicgarden/provider/topic_provider.dart';
import 'package:provider/provider.dart';

import '../logic/pg_error.dart';
import '../provider/table_provider.dart';
import 'common/empty_refreshable.dart';
import 'order/add_order.dart';
import 'order/phase_loader.dart';
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
        _AppBar(
          provider.selectedTable.name,
          onTableTapped: () async {
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
    this.onTableTapped,
    Key key,
  }) : super(key: key);

  final String selectedTableName;
  final VoidCallback onTableTapped;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;

    final currentTableLabel = Row(
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
    );

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            child: currentTableLabel,
            onTap: () => onTableTapped?.call(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              color: Theme.of(context).colorScheme.onPrimary,
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider(
                      create: (_) => providers<TopicProvider>(),
                      child: TopicSubscriberDialog(),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class TopicSubscriberDialog extends StatelessWidget {
  const TopicSubscriberDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TopicProvider>();

    var content = <Widget>[Center(child: CircularProgressIndicator())];
    if (!provider.isLoading) {
      content = provider.topics
          .map((topic) => CheckboxListTile(
                title: Text(topic.name),
                controlAffinity: ListTileControlAffinity.leading,
                value: provider.isSubscribedToTopic(topic),
                onChanged: (value) {
                  provider.setSubscribedToTopic(value, topic: topic);
                },
              ))
          .toList();
    }

    return AlertDialog(
      elevation: 2,
      title: Text('Subscribed topics'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [...content],
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        )
      ],
    );
  }
}
