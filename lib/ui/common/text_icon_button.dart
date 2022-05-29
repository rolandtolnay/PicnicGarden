import 'package:flutter/material.dart';

// TODO: Consolidate all button classes into one
class TextIconButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const TextIconButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.onPrimary, size: 16),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: textTheme.bodyText2?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
