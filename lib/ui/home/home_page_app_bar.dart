import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:provider/provider.dart';

import '../../domain/model/table_entity.dart';
import '../theme_provider.dart';
import 'table/table_name_widget.dart';
import 'topic/topic_subscriber_dialog.dart';

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
    final themeProvider = context.watch<ThemeModeProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.primary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: !kIsWeb,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                color: colorScheme.onPrimary,
                icon: Icon(Icons.notifications),
                onPressed: () => TopicSubscriberDialog.show(context),
              ),
            ),
          ),
          TableNameWidget(
            table: selectedTable,
            showNotifications: true,
            onTapped: onTableTapped,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                themeProvider.setThemeMode(
                  isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
              },
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              color: colorScheme.onPrimary,
            ),
          )
        ],
      ),
    );
  }
}
