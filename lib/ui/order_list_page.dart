import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:picnicgarden/model/order.dart';
import 'package:picnicgarden/model/phase.dart';
import 'package:picnicgarden/provider/phase_provider.dart';
import 'package:provider/provider.dart';

import '../logic/pg_error.dart';
import '../provider/order_provider.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final phases = context.watch<PhaseProvider>().phases;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // if (provider.orders.isEmpty) {
    //   return RefreshIndicator(
    //     onRefresh: provider.fetchOrders,
    //     child: Stack(
    //       children: [
    //         ListView(),
    //         Center(
    //             child: Text('No orders found.',
    //                 style: Theme.of(context).textTheme.subtitle1)),
    //       ],
    //     ),
    //   );
    // }

    final builder = ItemBuilder(orders: provider.orders, phases: phases);

    return ListView(
        children: builder
            .buildListItems()
            .map((listItem) => ListTile(title: listItem.buildContent(context)))
            .toList());
  }
}

class ItemBuilder {
  final List<Phase> phases;
  final List<Order> orders;

  ItemBuilder({this.phases, this.orders});

  List<ListItem> buildListItems() {
    final sortedPhases = List.from(phases);
    sortedPhases.sort((a, b) => a.number.compareTo(b.number));

    final phaseMap = orders.fold(<String, List<Order>>{}, (map, order) {
      var phaseKey = 'unknown';
      if (order.phase != null) {
        phaseKey = order.phase.id;
      }
      if (map[phaseKey] == null) {
        map[phaseKey] = [order];
      } else {
        map[phaseKey].add(order);
      }
      return map;
    });

    return sortedPhases.fold(<ListItem>[], (list, phase) {
      list.add(PhaseItem(phase));
      if (phaseMap[phase.id] != null) {
        list.addAll(phaseMap[phase.id].map((order) => OrderItem(order)));
      }
      return list;
    });
  }
}

abstract class ListItem {
  Widget buildContent(BuildContext context);
}

class PhaseItem implements ListItem {
  final Phase phase;

  PhaseItem(this.phase);

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      child: Text('Phase: ${phase.name}'),
    );
  }
}

class OrderItem implements ListItem {
  final Order order;

  OrderItem(this.order);

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      child: Text('Order ${order.recipe.name}'),
    );
  }
}
