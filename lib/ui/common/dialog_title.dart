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
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8.0),
        Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: color,
              ),
        ),
      ],
    );
  }
}
