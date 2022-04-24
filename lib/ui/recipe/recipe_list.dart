import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/order.dart';
import '../../model/phase.dart';
import '../../model/recipe.dart';
import '../../provider/order/order_builder.dart';
import '../../provider/phase_provider.dart';
import '../phase/phase_picker_dialog.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipeList;
  final ValueChanged<Order>? onOrderCreated;

  const RecipeList({required this.recipeList, this.onOrderCreated, Key? key})
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

    Phase? phase;
    if (recipe.autoPhase == null || recipe.autoPhase!.isEmpty) {
      phase = await context.showPhasePicker(
        phaseList: phases.where((p) => p.selectable).toList(),
      );
    } else {
      phase = phases.firstWhereOrNull((p) => p.id == recipe.autoPhase);
    }
    if (phase == null) return;

    context.read<OrderBuilder>().setRecipe(recipe);
    context.read<OrderBuilder>().setPhase(phase);
    final order = context.read<OrderBuilder>().makeOrder();
    if (order != null) {
      onOrderCreated?.call(order);
    }
  }
}
