import 'dart:async';

import 'package:flutter/material.dart';

import 'items/order_list_item_builder.dart';
import 'items/order_list_phase_item.dart';

class OrderList extends StatefulWidget {
  final List<OrderListItem> items;
  final bool showTimer;

  const OrderList({
    required this.items,
    required this.showTimer,
    Key? key,
  }) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.showTimer) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {});
      });
    }
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
          elevation: listItem is OrderListPhaseItem ? 4 : 0,
          color: color,
          child: listItem.buildContent(context),
        );
      }).toList(),
    );
  }
}
