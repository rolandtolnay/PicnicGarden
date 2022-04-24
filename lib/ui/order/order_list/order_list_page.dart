import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:picnicgarden/ui/home/table/table_filter_provider.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/attribute.dart';
import '../../../domain/pg_error.dart';
import '../../../domain/model/table_entity.dart';
import '../order_provider.dart';
import 'order_status_provider.dart';
import '../../phase/phase_provider.dart';
import 'order_list_item_builder.dart';
import 'order_list_phase_item.dart';

class OrderListPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final phases = context.watch<PhaseProvider>().phases;
    final orderStatusList =
        context.watch<OrderStatusProvider>().orderStatusList;
    final enabledAttributes =
        context.select<TableFilterProvider, Iterable<Attribute>>(
      (p) => p.enabledAttributes,
    );

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final builder = OrderListItemBuilder(
      orders: provider
          .ordersForTable(table)
          .filteredBy(enabledAttributes: enabledAttributes),
      phases: phases,
      showTimer: showTimer,
      onOrderTapped: (order) async {
        final provider = context.read<OrderProvider>();
        final error = await provider.commitNextFlow(
          order: order,
          orderStatusList: orderStatusList,
        );
        error?.showInDialog(context);
      },
    );
    return _OrderList(
      items: builder.buildListItems(),
      showTimer: showTimer,
      scrollable: scrollable,
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
