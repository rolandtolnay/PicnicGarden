import 'package:flutter/material.dart';

import '../../model/phase.dart';
import '../common/dialog_title.dart';
import '../common/list_item_widget.dart';

class PhasePickerDialog extends StatelessWidget {
  final List<Phase> phaseList;

  const PhasePickerDialog({required this.phaseList, Key? key})
      : super(key: key);

  static Future<Phase?> show(
    BuildContext context, {
    required List<Phase> phaseList,
  }) {
    return showDialog(
      context: context,
      builder: (_) => PhasePickerDialog(phaseList: phaseList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const DialogTitle(text: 'Choose phase', icon: Icons.timelapse),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: phaseList.map((p) => _buildPhaseItem(p, context)).toList(),
      ),
    );
  }

  Padding _buildPhaseItem(Phase phase, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListItemWidget(
        phase.name,
        onTapped: () => Navigator.of(context).pop(phase),
      ),
    );
  }
}
