import 'package:flutter/material.dart';

import 'build_context_ext_screen_size.dart';
import 'max_width_container.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return ConfirmationDialog._(title: title, description: description);
      },
    );
  }

  const ConfirmationDialog._({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaxWidthContainer(
      maxWidth: kPhoneWidth,
      child: AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('CONFIRM'),
          ),
        ],
      ),
    );
  }
}
