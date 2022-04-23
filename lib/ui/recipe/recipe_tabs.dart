import 'package:flutter/material.dart';

import '../../model/order.dart';
import '../../model/recipe.dart';
import 'recipe_list.dart';

enum RecipeTabs { food, drink }

extension WidgetBuilders on RecipeTabs {
  Widget buildTab(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8.0),
          Text(title),
        ],
      ),
    );
  }

  Widget buildView(
    BuildContext context, {
    required List<Recipe> allRecipes,
    ValueChanged<Order>? onOrderCreated,
  }) {
    final recipes = allRecipes
        .where((r) => r.tabIndex == RecipeTabs.values.indexOf(this))
        .toList();
    return RecipeList(recipeList: recipes, onOrderCreated: onOrderCreated);
  }

  IconData get icon {
    switch (this) {
      case RecipeTabs.food:
        return Icons.lunch_dining;
      case RecipeTabs.drink:
        return Icons.local_bar;
    }
  }

  String get title {
    switch (this) {
      case RecipeTabs.food:
        return 'Food';
      case RecipeTabs.drink:
        return 'Drinks';
    }
  }
}
