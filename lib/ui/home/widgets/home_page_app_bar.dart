import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Table;

import '../../../model/table_entity.dart';
import 'table_name_widget.dart';
import 'topic_subscriber_dialog.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.primary,
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
                color: colorScheme.onPrimary,
                icon: Icon(Icons.settings),
                onPressed: () => TopicSubscriberDialog.show(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
