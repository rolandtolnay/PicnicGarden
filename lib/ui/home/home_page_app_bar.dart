import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:picnicgarden/provider/notification_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/providers.dart';
import '../../provider/topic_provider.dart';
import 'topic_subscriber_dialog.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar(
    this.selectedTableName, {
    this.onTableTapped,
    Key key,
  }) : super(key: key);

  final String selectedTableName;
  final VoidCallback onTableTapped;

  @override
  Widget build(BuildContext context) {
    final notificationCount = context
        .watch<NotificationProvider>()
        .notificationsExcludingTable(selectedTableName)
        .length;

    final textColor = Theme.of(context).colorScheme.onPrimary;

    final currentTableLabel = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.tab, size: 24, color: textColor),
        const SizedBox(width: 8.0),
        Badge(
          showBadge: notificationCount != 0,
          badgeContent: Text(
            '${notificationCount}',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          position: BadgePosition.topStart(),
          animationType: BadgeAnimationType.fade,
          padding: const EdgeInsets.all(8.0),
          child: Text(selectedTableName,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: textColor)),
        ),
        const SizedBox(width: 16.0),
      ],
    );

    void onSettingsPressed() {
      showDialog(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => providers<TopicProvider>(),
            child: TopicSubscriberDialog(),
          );
        },
      );
    }

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
              onPressed: onSettingsPressed,
            ),
          )
        ],
      ),
    );
  }
}
