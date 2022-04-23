import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../logic/pg_error.dart';
import '../../../model/order.dart';
import '../../../provider/recipe_provider.dart';
import '../../common/empty_refreshable.dart';
import 'recipe_tabs.dart';

class OrderAddDialog extends StatelessWidget {
  final ValueChanged<Order>? onOrderCreated;

  const OrderAddDialog({Key? key, required this.onOrderCreated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final provider = context.watch<RecipeProvider>();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
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
        indicatorColor: Colors.white,
      ),
    );
    final tabBarView = Builder(
      builder: (context) => TabBarView(
        children: RecipeTabs.values
            .map(
              (tab) => tab.buildView(
                context,
                allRecipes: provider.recipes,
                onOrderCreated: onOrderCreated,
              ),
            )
            .toList(),
      ),
    );
    final cancelButton = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text('CANCEL'),
    );

    return Dialog(
      elevation: 2,
      child: DefaultTabController(
        length: RecipeTabs.values.length,
        child: Scaffold(
          persistentFooterButtons: [cancelButton],
          body: Column(
            children: [
              tabBar,
              Expanded(child: tabBarView),
            ],
          ),
        ),
      ),
    );
  }
}
