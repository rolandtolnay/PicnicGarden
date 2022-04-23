import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:picnicgarden/ui/common/build_context_ext_screen_size.dart';
import 'package:picnicgarden/ui/common/max_width_container.dart';
import 'package:provider/provider.dart';

import '../../../logic/pg_error.dart';
import '../../../model/order.dart';
import '../../../provider/order/order_provider.dart';
import '../../../provider/recipe_provider.dart';
import '../../common/empty_refreshable.dart';
import '../../common/snackbar_builder.dart';
import '../../recipe/recipe_tabs.dart';

class OrderAddDialog extends StatelessWidget {
  const OrderAddDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                onOrderCreated: (o) => _onOrderCreated(o, context),
              ),
            )
            .toList(),
      ),
    );
    final cancelButton = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text('CANCEL'),
    );

    return MaxWidthContainer(
      child: Dialog(
        elevation: 2,
        child: DefaultTabController(
          length: RecipeTabs.values.length,
          child: Scaffold(
            body: Column(
              children: [
                tabBar,
                Expanded(child: tabBarView),
                Divider(height: 8, thickness: 2),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(context.isTabletScreen ? 16.0 : 8),
                    child: cancelButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onOrderCreated(Order order, BuildContext context) async {
    final error = await context.read<OrderProvider>().commitOrder(order);
    if (error != null) return error.showInDialog(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarBuilder.orderSucces(order, context),
    );
  }
}