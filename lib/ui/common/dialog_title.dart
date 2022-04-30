import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle({
    required this.text,
    required this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          Icon(icon, color: color),
          const SizedBox(width: 8.0),
          Text(text, style: textTheme.headline5?.copyWith(color: color)),
        ],
      ),
    );
  }
}
