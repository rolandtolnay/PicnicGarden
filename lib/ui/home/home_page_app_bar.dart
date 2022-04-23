import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../logic/pg_error.dart';
import '../../model/table.dart';
import '../../provider/notification_provider.dart';
import '../../provider/topic_provider.dart';
import 'topic_subscriber_dialog.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar(
    this.selectedTable, {
    this.onTableTapped,
    Key? key,
  }) : super(key: key);

  final Table selectedTable;
  final VoidCallback? onTableTapped;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });

    final notificationCount =
        provider.notificationsExcludingTable(selectedTable).length;
    final textColor = Theme.of(context).colorScheme.onPrimary;

    final currentTableLabel = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.tab, size: 24, color: textColor),
        const SizedBox(width: 8.0),
        Badge(
          showBadge: notificationCount != 0,
          badgeContent: Text(
            '$notificationCount',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          toAnimate: false,
          position: BadgePosition.topStart(),
          padding: const EdgeInsets.all(8.0),
          child: Text(selectedTable.name,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: textColor)),
        ),
        const SizedBox(width: 16.0),
      ],
    );

    void onSettingsPressed() {
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

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () => onTableTapped?.call(),
            child: currentTableLabel,
          ),
          Visibility(
            visible: !kIsWeb,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                color: Theme.of(context).colorScheme.onPrimary,
                icon: Icon(Icons.settings),
                onPressed: onSettingsPressed,
              ),
            ),
          )
        ],
      ),
    );
  }
}
