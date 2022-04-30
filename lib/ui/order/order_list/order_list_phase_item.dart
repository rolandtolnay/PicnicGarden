import 'package:flutter/material.dart';

import '../../../domain/model/phase.dart';
import 'order_list_item_builder.dart';

class OrderListPhaseItem implements OrderListItem<Phase> {
  final Phase phase;

  OrderListPhaseItem(this.phase);

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return ListTile(
      enabled: false,
      tileColor: colorScheme.surface,
      dense: true,
      title: Row(
        children: [
          Icon(Icons.timelapse, color: theme.unselectedWidgetColor),
          const SizedBox(width: 8.0),
          Text(
            phase.name.toUpperCase(),
            style: textTheme.subtitle2
                ?.copyWith(color: theme.unselectedWidgetColor),
          ),
        ],
      ),
    );
  }

  @override
  Color? get backgroundColor => null;
}
