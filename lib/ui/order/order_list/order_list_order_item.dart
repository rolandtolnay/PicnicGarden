import 'package:flutter/material.dart';

import '../../../domain/extensions.dart';
import '../../../domain/model/order/order.dart';
import '../../../domain/model/order/order_group.dart';
import 'order_list_item_builder.dart';

class OrderListOrderItem implements OrderListItem<Order> {
  final OrderGroup orderGroup;
  final bool showTimer;

  final ValueChanged<OrderGroup>? onTapped;

  OrderListOrderItem(
    this.orderGroup, {
    required this.showTimer,
    this.onTapped,
  }) : assert(orderGroup.orderList.isNotEmpty);

  @override
  Color? get backgroundColor => HexColor.fromHex(orderGroup.colorHex);

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final count = orderGroup.orderList.length;
    final countVisible = orderGroup.orderList.length > 1;
    final orderCount = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: countVisible ? theme.disabledColor : null,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Visibility(
        visible: countVisible,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$count',
                style: textTheme.headline4
                    ?.copyWith(color: colorScheme.onSurface)),
            Text('x', style: textTheme.caption),
          ],
        ),
      ),
    );

    return ListTile(
      onTap: () => onTapped?.call(orderGroup),
      contentPadding: EdgeInsets.fromLTRB(4, 8, 8, 4),
      title: Row(
        children: [
          orderCount,
          const SizedBox(width: 4.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderGroup.recipe.name.capitalized,
                  style: textTheme.headline6,
                ),
                if (orderGroup.customNote != null) ...[
                  const SizedBox(height: 4.0),
                  Text(orderGroup.customNote!, style: textTheme.caption)
                ],
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                orderGroup.currentStatus.name,
                style: textTheme.bodyText2!
                    .copyWith(color: theme.unselectedWidgetColor),
              ),
              if (showTimer) ...[
                const SizedBox(height: 4.0),
                Text(
                  orderGroup.currentDuration.description,
                  style: textTheme.headline5,
                )
              ]
            ],
          )
        ],
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
