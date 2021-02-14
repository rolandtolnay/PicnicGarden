import 'package:flutter/material.dart';

import 'rectangular_button.dart';

class DialogItem extends StatelessWidget {
  const DialogItem(
    this.title, {
    this.onTapped,
    this.isSelected = false,
    Key key,
  }) : super(key: key);

  final String title;
  final VoidCallback onTapped;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryVariant;
    final textColor =
        isSelected ? Theme.of(context).colorScheme.onPrimary : color;
    final textStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        );

    return isSelected
        ? RectangularButton.flat(
            title: title,
            textStyle: textStyle,
            onPressed: () => onTapped?.call(),
          )
        : RectangularButton.outlined(
            title: title,
            textStyle: textStyle,
            onPressed: () => onTapped?.call(),
          );
  }
}
