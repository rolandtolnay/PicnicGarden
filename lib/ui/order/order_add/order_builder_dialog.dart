import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/order.dart';
import '../../../domain/model/phase.dart';
import '../../../domain/model/recipe.dart';
import '../../common/build_context_ext_screen_size.dart';
import '../../common/common_dialog.dart';
import '../../common/dialog_cancel_button.dart';
import '../../common/dialog_title.dart';
import '../../common/rectangular_button.dart';
import 'order_builder.dart';

/// Dialog for picking order phase and adding a custom note
class OrderBuilderDialog extends StatelessWidget {
  final List<Phase> phaseList;
  final Recipe recipe;

  const OrderBuilderDialog({
    required this.phaseList,
    required this.recipe,
    Key? key,
  }) : super(key: key);

  static Future<Order?> show(
    BuildContext context, {
    required List<Phase> phaseList,
    required Recipe recipe,
  }) async {
    return showDialog(
      context: context,
      builder: (_) => Provider.value(
        value: context.read<OrderBuilder>(),
        child: OrderBuilderDialog(phaseList: phaseList, recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final border = UnderlineInputBorder(
      borderSide: BorderSide(width: 1, color: colorScheme.primary),
    );
    return CommonDialog(
      maxWidth: kPhoneWidth,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogTitle(
              text: 'Confirm order',
              icon: Icons.pending_actions,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Custom note',
                  enabledBorder: border,
                  focusedBorder: border,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            if (recipe.shouldPickPhase) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timelapse),
                  const SizedBox(width: 4.0),
                  Text('Choose phase', style: textTheme.subtitle1),
                ],
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                children: phaseList
                    .where((p) => p.selectable)
                    .map((p) => _buildPhaseItem(p, context))
                    .toList(),
              ),
            ] else ...[
              _buildAutoPhaseButton(context)
            ],
            const DialogCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoPhaseButton(BuildContext context) {
    final phase = phaseList.firstWhereOrNull(
      (p) => p.id == recipe.autoPhase,
    );
    final phaseTitle = phase != null ? ' FOR ${phase.name}' : '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RectangularButton.flat(
        title: 'CONFIRM$phaseTitle',
        onPressed: () {
          final builder = context.read<OrderBuilder>();
          builder.setRecipe(recipe);
          if (phase != null) builder.setPhase(phase);
          final order = builder.makeOrder();
          Navigator.of(context).pop(order);
        },
      ),
    );
  }

  Widget _buildPhaseItem(Phase phase, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RectangularButton.flat(
        title: phase.name,
        onPressed: () {
          final builder = context.read<OrderBuilder>();
          builder.setRecipe(recipe);
          builder.setPhase(phase);
          final order = builder.makeOrder();
          Navigator.of(context).pop(order);
        },
      ),
    );
  }
}

extension on Recipe {
  bool get shouldPickPhase => autoPhase == null || autoPhase!.isEmpty;
}
