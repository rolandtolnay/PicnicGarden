import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../logic/pg_error.dart';
import '../../provider/order_builder.dart';
import '../../provider/order_provider.dart';
import '../../provider/order_status_provider.dart';
import '../../provider/phase_provider.dart';
import '../../provider/providers.dart';
import '../../provider/recipe_provider.dart';
import '../../provider/table_provider.dart';
import '../common/empty_refreshable.dart';
import '../common/snackbar_builder.dart';
import '../recipe_list.dart';

class AddOrderButton extends StatelessWidget {
  const AddOrderButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableProvider = context.watch<TableProvider>();
    final orderStatusProvider = context.watch<OrderStatusProvider>();
    if (tableProvider.isLoading ||
        orderStatusProvider.isLoading ||
        orderStatusProvider.orderStatusList.isEmpty) {
      return Container();
    }

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        final order = await showDialog(
          context: context,
          builder: (_) {
            return Provider(
              create: (_) => providers<OrderBuilder>()
                ..setTable(tableProvider.selectedTable)
                ..setOrderStatus(orderStatusProvider.orderStatusList.first),
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(
                    value: context.read<RecipeProvider>(),
                  ),
                  ChangeNotifierProvider.value(
                    value: context.read<PhaseProvider>(),
                  ),
                  ChangeNotifierProvider.value(
                    value: context.read<OrderProvider>(),
                  )
                ],
                child: AddOrderDialog(),
              ),
            );
          },
        );
        if (order != null) {
          print('Added $order');
        }
      },
    );
  }
}

class AddOrderDialog extends StatelessWidget {
  const AddOrderDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(elevation: 2, child: _AddOrderDialogBody());
  }
}

class _AddOrderDialogBody extends StatelessWidget {
  const _AddOrderDialogBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    final foodTab = Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lunch_dining),
          SizedBox(width: 8.0),
          Text('Food'),
        ],
      ),
    );

    final drinkTab = Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_bar),
          SizedBox(width: 8.0),
          Text('Drinks'),
        ],
      ),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          bottom: TabBar(tabs: [foodTab, drinkTab]),
        ),
        persistentFooterButtons: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL'),
          )
        ],
        body: Builder(
          builder: (context) {
            void onOrderCreated(order) async {
              final error =
                  await context.read<OrderProvider>().commitOrder(order);
              if (error == null) {
                Scaffold.of(context).showSnackBar(
                  SnackBarBuilder.orderSucces(order, context),
                );
              } else {
                error.showInDialog(context);
              }
            }

            final food = provider.recipes
                .where((recipe) => recipe.tabIndex == 0)
                .toList();
            final drinks = provider.recipes
                .where((recipe) => recipe.tabIndex == 1)
                .toList();

            return TabBarView(
              children: [
                RecipeList(food, onOrderCreated: onOrderCreated),
                RecipeList(drinks, onOrderCreated: onOrderCreated),
              ],
            );
          },
        ),
      ),
    );
  }
}
