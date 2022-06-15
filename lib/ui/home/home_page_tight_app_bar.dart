import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:provider/provider.dart';

import '../../domain/model/table_entity.dart';
import '../theme_provider.dart';
import 'table/widgets/table_name_widget.dart';
import 'topic/topic_provider.dart';
import 'topic/topic_subscriber_dialog.dart';

class HomePageTightAppBar extends StatelessWidget {
  final TableEntity selectedTable;
  final VoidCallback? onTableTapped;

  const HomePageTightAppBar(
    this.selectedTable, {
    this.onTableTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final notificationButton = Visibility(
      visible: !kIsWeb,
      child: Consumer<TopicProvider>(
        builder: (context, provider, _) => Align(
          alignment: Alignment.centerLeft,
          child: Badge(
            showBadge: !provider.isLoading &&
                provider.topics.every((e) => !provider.isSubscribedToTopic(e)),
            position: BadgePosition.bottomEnd(bottom: -4, end: 0),
            padding: const EdgeInsets.all(6.0),
            toAnimate: false,
            badgeContent: Text(
              '0',
              style:
                  textTheme.bodyText1!.copyWith(color: colorScheme.onPrimary),
            ),
            child: IconButton(
              color: colorScheme.onPrimary,
              icon: Icon(Icons.notifications),
              onPressed: () => TopicSubscriberDialog.show(context),
            ),
          ),
        ),
      ),
    );
    final themeButton = Consumer<ThemeModeProvider>(
      builder: (_, provider, __) => Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: () {
            provider.setThemeMode(
              isDarkMode ? ThemeMode.light : ThemeMode.dark,
            );
          },
          icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          color: colorScheme.onPrimary,
        ),
      ),
    );

    return Container(
      color: selectedTable.status?.backgroundColor ?? colorScheme.primary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          notificationButton,
          TableNameWidget(
            table: selectedTable,
            showNotifications: true,
            onTapped: onTableTapped,
          ),
          themeButton
        ],
      ),
    );
  }
}
