import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../domain/extensions.dart';
import '../../../domain/model/order.dart';
import 'order_list_item_builder.dart';

class OrderListOrderItem implements OrderListItem<Order> {
  final List<Order> orderList;
  final bool showTimer;

  final ValueChanged<List<Order>>? onTapped;

  OrderListOrderItem(
    this.orderList, {
    required this.showTimer,
    this.onTapped,
  }) : assert(orderList.isNotEmpty);

  @override
  Color? get backgroundColor => orderList.isEmpty
      ? null
      : HexColor.fromHex(orderAlpha.currentStatus.colorHex);

  Order get orderAlpha =>
      orderList.sorted((a, b) => a.createdAt.compareTo(b.createdAt)).first;

  @override
  Widget buildContent(BuildContext context) {
    if (orderList.isEmpty) return Container();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // TODO: Replace with orderlist count
    final randomCount = Random().nextInt(7) + 2;
    return ListTile(
      onTap: () => onTapped?.call(orderList),
      contentPadding: EdgeInsets.fromLTRB(4, 8, 8, 4),
      title: Row(
        children: [
          Visibility(
            visible: orderList.length > 1,
            child: Text('${randomCount}x', style: textTheme.headline6),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderAlpha.recipe.name.capitalized,
                  style: textTheme.headline6,
                ),
                if (orderAlpha.customNote != null) ...[
                  const SizedBox(height: 4.0),
                  Text(orderAlpha.customNote!, style: textTheme.caption)
                ],
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                orderAlpha.currentStatus.name,
                style: textTheme.bodyText2!
                    .copyWith(color: theme.unselectedWidgetColor),
              ),
              if (showTimer) ...[
                const SizedBox(height: 4.0),
                Text(
                  orderAlpha.currentDuration.description,
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
