import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/table_entity.dart';
import '../topic/notification_provider.dart';

class TableNameWidget extends StatelessWidget {
  final TableEntity table;
  final bool showNotifications;
  final VoidCallback? onTapped;

  const TableNameWidget({
    Key? key,
    required this.table,
    required this.showNotifications,
    this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onPrimary;

    Widget label = Text(
      table.name,
      style: textTheme.headline2!.copyWith(color: textColor),
    );
    if (showNotifications) {
      final provider = context.watch<NotificationProvider>();
      final count = provider.notificationsExcludingTable(table).length;
      label = Badge(
        showBadge: count != 0,
        badgeContent: Text(
          '$count',
          style: textTheme.bodyText1!.copyWith(color: colorScheme.onPrimary),
        ),
        toAnimate: false,
        position: BadgePosition.topStart(),
        padding: const EdgeInsets.all(8.0),
        child: label,
      );
    }

    return InkWell(
      onTap: onTapped,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tab, size: 24, color: textColor),
          const SizedBox(width: 8.0),
          label,
          const SizedBox(width: 16.0),
        ],
      ),
    );
  }
}
