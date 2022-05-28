import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/attribute.dart';
import '../../../domain/model/order/order_status.dart';
import '../../../domain/model/phase.dart';
import '../../../domain/model/table_entity.dart';
import '../../../domain/service_error.dart';
import '../../home/table/table_filter_provider.dart';
import '../../phase/phase_provider.dart';
import '../order_provider.dart';
import 'order_list_item_builder.dart';
import 'order_list_phase_item.dart';
import 'order_status_provider.dart';

class OrderListPage extends StatefulWidget {
  final TableEntity table;
  final bool showTimer;
  final bool scrollable;

  const OrderListPage({
    Key? key,
    required this.table,
    required this.showTimer,
    required this.scrollable,
  }) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final phases = context.select<PhaseProvider, Iterable<Phase>>(
      (p) => p.phases,
    );
    final orderStatusList =
        context.select<OrderStatusProvider, List<OrderStatus>>(
      (p) => p.orderStatusList,
    );
    final enabledAttributes =
        context.select<TableFilterProvider, Iterable<Attribute>>(
      (p) => p.enabledAttributes,
    );

    final builder = OrderListItemBuilder(
      orderGroupList: provider
          .orderGroupList(table: widget.table)
          .filteredBy(enabledAttributes: enabledAttributes),
      phaseList: phases,
      showTimer: widget.showTimer,
      onOrderTapped: (orderGroup) async {
        final provider = context.read<OrderProvider>();
        await provider.commitNextFlow(
          orderGroup: orderGroup,
          orderStatusList: orderStatusList,
        );

        if (!mounted) return;
        if (provider.hasError) context.showError(provider);
      },
    );
    return _OrderList(
      items: builder.buildListItems(),
      showTimer: widget.showTimer,
      scrollable: widget.scrollable,
    );
  }
}

class _OrderList extends StatefulWidget {
  final List<OrderListItem> items;
  final bool showTimer;
  final bool scrollable;

  const _OrderList({
    required this.items,
    required this.showTimer,
    required this.scrollable,
    Key? key,
  }) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<_OrderList> {
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
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: widget.scrollable,
      ),
      child: ListView(
        physics: !widget.scrollable ? NeverScrollableScrollPhysics() : null,
        padding: EdgeInsets.only(bottom: 56),
        children: widget.items.map((listItem) {
          final color = listItem.backgroundColor ?? Theme.of(context).cardColor;
          return Material(
            elevation: listItem is OrderListPhaseItem ? 4 : 0,
            color: color,
            child: listItem.buildContent(context),
          );
        }).toList(),
      ),
    );
  }
}
