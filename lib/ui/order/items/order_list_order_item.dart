import 'package:flutter/material.dart';

import '../../../logic/extensions.dart';
import '../../../model/order.dart';
import 'order_list_item_builder.dart';

class OrderListOrderItem implements OrderListItem<Order> {
  final Order order;
  final bool showTimer;

  final ValueChanged<Order>? onTapped;

  OrderListOrderItem(this.order, {required this.showTimer, this.onTapped});

  @override
  Color get backgroundColor => HexColor.fromHex(order.currentStatus.colorHex);

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListTile(
      onTap: () => onTapped?.call(order),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                order.recipe.name.capitalized,
                style: textTheme.headline6,
              ),
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.currentStatus.name,
                  style: textTheme.bodyText2!
                      .copyWith(color: theme.unselectedWidgetColor),
                ),
                if (showTimer) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    order.currentDuration.description,
                    style: textTheme.headline5,
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}

extension on Duration {
  String get description {
    final hours = inHours;
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
}
