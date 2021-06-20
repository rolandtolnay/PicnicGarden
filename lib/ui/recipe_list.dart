import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/order.dart';
import '../model/phase.dart';
import '../model/recipe.dart';
import '../provider/order/order_builder.dart';
import '../provider/phase_provider.dart';
import 'common/dialog_item.dart';
import 'common/dialog_title.dart';

class RecipeList extends StatelessWidget {
  RecipeList(this.recipes, {this.onOrderCreated, Key key}) : super(key: key);

  final ValueChanged<Order> onOrderCreated;
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.separated(
          itemBuilder: (context, index) {
            final recipe = recipes[index];

            return ListTile(
              title: Text(recipe.name),
              onTap: () async {
                final phases = context.read<PhaseProvider>().phases;

                Phase phase;
                if (recipe.autoPhase == null || recipe.autoPhase.isEmpty) {
                  phase = await showDialog(
                    context: context,
                    builder: (_) => PhasePickerDialog(
                      phases.where((p) => p.selectable).toList(),
                    ),
                  );
                } else {
                  phase = phases.firstWhere(
                    (p) => p.id == recipe.autoPhase,
                    orElse: () => null,
                  );
                }

                if (phase != null) {
                  context.read<OrderBuilder>().setRecipe(recipe);
                  context.read<OrderBuilder>().setPhase(phase);
                  final order = context.read<OrderBuilder>().makeOrder();
                  if (order != null) {
                    onOrderCreated?.call(order);
                  }
                }
              },
            );
          },
          separatorBuilder: (_, __) => Divider(),
          itemCount: recipes.length),
    );
  }
}

class PhasePickerDialog extends StatelessWidget {
  const PhasePickerDialog(this.phases, {Key key}) : super(key: key);

  final List<Phase> phases;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const DialogTitle(text: 'Choose phase', icon: Icons.timelapse),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...phases.map((phase) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: DialogItem(
                  phase.name,
                  onTapped: () => Navigator.of(context).pop(phase),
                ),
              )),
        ],
      ),
    );
  }
}
