import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle({
    @required this.text,
    @required this.icon,
    Key key,
  }) : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8.0),
        Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
