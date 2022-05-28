import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/order.dart';
import '../../../domain/model/table_entity.dart';
import '../../../domain/pg_error.dart';
import '../../../injection.dart';
import '../../common/common_dialog.dart';
import '../../common/dialog_cancel_button.dart';
import '../../common/empty_refreshable.dart';
import '../../common/snackbar_builder.dart';
import '../../phase/phase_provider.dart';
import '../../recipe/recipe_provider.dart';
import '../../recipe/recipe_tabs.dart';
import '../order_list/order_status_provider.dart';
import '../order_provider.dart';
import 'order_builder.dart';

class OrderAddDialog extends StatefulWidget {
  const OrderAddDialog._({Key? key}) : super(key: key);

  static void show(BuildContext context, {required TableEntity table}) {
    showDialog(
      context: context,
      builder: (_) => context.buildOrderAdd(table: table),
    );
  }

  @override
  State<OrderAddDialog> createState() => _OrderAddDialogState();
}

class _OrderAddDialogState extends State<OrderAddDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<RecipeProvider>();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (provider.recipes.isEmpty) {
      return EmptyRefreshable(
        'No recipes found.',
        onRefresh: provider.fetchRecipes,
      );
    }

    final tabBar = Material(
      elevation: 4,
      color: colorScheme.primary,
      child: TabBar(
        labelPadding: const EdgeInsets.only(top: 8.0),
        tabs: RecipeTabs.values.map((tab) => tab.buildTab(context)).toList(),
      ),
    );
    final tabBarView = Builder(
      builder: (context) => TabBarView(
        children: RecipeTabs.values
            .map(
              (tab) => tab.buildView(
                context,
                allRecipes: provider.recipes,
                onOrderCreated: (o) => _onOrderCreated(o, context),
              ),
            )
            .toList(),
      ),
    );

    return CommonDialog(
      padding: EdgeInsets.zero,
      child: DefaultTabController(
        length: RecipeTabs.values.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              tabBar,
              Expanded(child: tabBarView),
              const Divider(height: 8, thickness: 2),
              const DialogCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onOrderCreated(Order order, BuildContext context) async {
    final error = await context.read<OrderProvider>().commitOrder(order);

    if (!mounted) return;
    if (error != null) return error.showInDialog(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarBuilder.orderSucces(order, context),
    );
  }
}

extension on BuildContext {
  Widget buildOrderAdd({required TableEntity table}) {
    final provider = read<OrderStatusProvider>();
    return Provider(
      create: (_) => getIt<OrderBuilder>()
        ..setTable(table)
        ..setOrderStatus(provider.orderStatusList.first),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: read<RecipeProvider>()),
          ChangeNotifierProvider.value(value: read<PhaseProvider>()),
          ChangeNotifierProvider.value(value: read<OrderProvider>())
        ],
        child: OrderAddDialog._(),
      ),
    );
  }
}
