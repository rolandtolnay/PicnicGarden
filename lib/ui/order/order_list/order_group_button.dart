import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/restaurant.dart';
import '../../../domain/model/table_entity.dart';
import '../../../injection.dart';
import '../../common/confirmation_dialog.dart';
import '../../common/text_icon_button.dart';
import '../../restaurant/restaurant_provider.dart';
import '../order_provider.dart';

class OrderGroupButton extends StatelessWidget {
  final bool hideLabel;
  final TableEntity table;

  const OrderGroupButton({Key? key, required this.table, this.hideLabel = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const icon = Icons.workspaces;
    return hideLabel
        ? IconButton(
            color: colorScheme.onPrimary,
            icon: Icon(icon),
            onPressed: () => onPressed(context),
          )
        : TextIconButton(
            icon: icon,
            title: 'GROUP ORDERS',
            onPressed: () => onPressed(context),
          );
  }

  void onPressed(BuildContext context) {
    final provider = context.read<OrderProvider>();
    final interval = getIt<RestaurantProvider>()
            .selectedRestaurant
            ?.orderGroupWarningInterval ??
        Restaurant.defaultOrderGroupWarningInterval;
    provider.groupSimilarOrders(
      table,
      interval: interval,
      shouldGroupBeyondInterval: (interval) async {
        final result = await ConfirmationDialog.show(
          context,
          title: 'Group all orders?',
          description:
              'Some orders have more than ${interval.inMinutes} minutes in-between them. Would you like to group these as well?',
        );
        return result ?? false;
      },
    );
  }
}
