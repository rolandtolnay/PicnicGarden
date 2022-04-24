import 'package:flutter/material.dart';

import '../../domain/model/phase.dart';
import '../common/dialog_title.dart';
import '../common/rectangular_button.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RectangularButton.outlined(
        title: phase.name,
        textColor: colorScheme.primary,
        borderColor: colorScheme.primaryContainer,
        onPressed: () => Navigator.of(context).pop(phase),
      ),
    );
  }
}
