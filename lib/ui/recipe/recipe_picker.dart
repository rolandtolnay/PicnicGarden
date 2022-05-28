import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/model/order/order.dart';
import '../../domain/model/recipe.dart';
import '../order/order_add/order_builder_dialog.dart';
import '../phase/phase_provider.dart';

class RecipePicker extends StatelessWidget {
  final List<Recipe> recipeList;
  final ValueChanged<Order>? onOrderCreated;

  const RecipePicker({required this.recipeList, this.onOrderCreated, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: recipeList.length,
      itemBuilder: (context, index) {
        final recipe = recipeList[index];
        return ListTile(
          title: Text(recipe.name),
          onTap: () => _onRecipeTapped(recipe, context),
        );
      },
      separatorBuilder: (_, __) => Divider(),
    );
  }

  void _onRecipeTapped(Recipe recipe, BuildContext context) async {
    final phases = context.read<PhaseProvider>().phases;
    final order = await OrderBuilderDialog.show(
      context,
      phaseList: phases,
      recipe: recipe,
    );
    if (order != null) onOrderCreated?.call(order);
  }
}
