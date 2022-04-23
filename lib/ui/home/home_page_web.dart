import 'package:flutter/material.dart';
import 'package:picnicgarden/ui/home/widgets/table_name_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/di.dart';
import '../../provider/notification_provider.dart';
import '../../provider/order/order_provider.dart';
import '../../provider/order/order_status_provider.dart';
import '../../provider/phase_provider.dart';
import '../../provider/recipe_provider.dart';
import '../../provider/table_provider.dart';
import '../../provider/topic_provider.dart';
import '../order/order_list_page.dart';

class HomePageWeb extends StatelessWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: di<TableProvider>()),
        ChangeNotifierProvider.value(value: di<TopicProvider>()),
        ChangeNotifierProvider.value(value: di<NotificationProvider>()),
        ChangeNotifierProvider(create: (_) => di<OrderProvider>()),
        ChangeNotifierProvider(create: (_) => di<RecipeProvider>()),
        ChangeNotifierProvider(create: (_) => di<PhaseProvider>()),
        ChangeNotifierProvider(create: (_) => di<RecipeProvider>()),
        ChangeNotifierProvider(create: (_) => di<OrderStatusProvider>()),
      ],
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          bottom: false,
          child: Scaffold(body: _HomePageWebBody()),
        ),
      ),
    );
  }
}

class _HomePageWebBody extends StatelessWidget {
  const _HomePageWebBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableProvider = context.watch<TableProvider>();
    if (tableProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return GridView.count(
      crossAxisCount: 4,
      childAspectRatio: 0.7,
      children: tableProvider.tables
          .map(
            (table) => Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: TableNameWidget(
                    table: table,
                    showNotifications: false,
                  ),
                ),
                Expanded(child: OrderListPage(table: table, showTimer: false)),
              ],
            ),
          )
          .toList(),
    );
  }
}
