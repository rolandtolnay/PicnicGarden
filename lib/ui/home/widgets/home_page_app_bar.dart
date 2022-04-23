import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Table;

import 'package:provider/provider.dart';

import '../../../model/table_entity.dart';
import '../../../provider/topic_provider.dart';
import 'topic_subscriber_dialog.dart';
import 'table_name_widget.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar(
    this.selectedTable, {
    this.onTableTapped,
    Key? key,
  }) : super(key: key);

  final TableEntity selectedTable;
  final VoidCallback? onTableTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TableNameWidget(
            table: selectedTable,
            showNotifications: true,
            onTapped: onTableTapped,
          ),
          Visibility(
            visible: !kIsWeb,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                color: Theme.of(context).colorScheme.onPrimary,
                icon: Icon(Icons.settings),
                onPressed: () => onSettingsPressed(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onSettingsPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: context.read<TopicProvider>(),
          child: TopicSubscriberDialog(),
        );
      },
    );
  }
}
