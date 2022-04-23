import 'package:flutter/material.dart';

import '../../../model/phase.dart';
import '../../common/dialog_title.dart';
import 'order_list_item_builder.dart';

class OrderListPhaseItem implements OrderListItem<Phase> {
  final Phase phase;

  OrderListPhaseItem(this.phase);

  @override
  Widget buildContent(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      title: DialogTitle(
        text: phase.name,
        icon: Icons.timelapse,
        color: Theme.of(context).unselectedWidgetColor,
      ),
    );
  }

  @override
  Color? get backgroundColor => null;
}
