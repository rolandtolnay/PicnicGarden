import 'dart:async';

import 'package:flutter/material.dart';

import '../../logic/extensions.dart';
import '../../model/order.dart';
import '../../model/phase.dart';
import '../common/dialog_title.dart';
import 'order_list_page.dart';

class OrderList extends StatefulWidget {
  const OrderList(this.items, {this.onOrderTapped, Key? key}) : super(key: key);

  final List<ListItem> items;
  final ValueChanged<Order>? onOrderTapped;

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 56),
      children: widget.items.map((listItem) {
        final color = listItem.backgroundColor ?? Theme.of(context).cardColor;
        return Material(
          elevation: listItem is PhaseItem ? 4 : 0,
          color: color,
          child: InkWell(
            onTap: () {
              if (listItem is OrderItem) {
                widget.onOrderTapped?.call(listItem.order);
              }
            },
            child: listItem.buildContent(context),
          ),
        );
      }).toList(),
    );
  }
}

class PhaseItem implements ListItem<Phase> {
  final Phase phase;

  PhaseItem(this.phase);

  @override
  Widget buildContent(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      title: DialogTitle(
        text: phase.name,
        icon: Icons.timelapse,
        color: Theme.of(context).unselectedWidgetColor,
      ),
    );
  }

  @override
  Color? get backgroundColor => null;
}

class OrderItem implements ListItem<Order> {
  final Order order;

  OrderItem(this.order);

  @override
  Color get backgroundColor => HexColor.fromHex(order.currentStatus.colorHex);

  @override
  Widget buildContent(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(order.recipe.name.capitalized,
                style: Theme.of(context).textTheme.headline6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(order.currentStatus.name,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).unselectedWidgetColor)),
                const SizedBox(height: 4.0),
                Text(order.currentDuration.description,
                    style: Theme.of(context).textTheme.headline5)
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
