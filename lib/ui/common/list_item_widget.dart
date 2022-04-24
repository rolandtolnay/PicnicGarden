import 'package:flutter/material.dart';

import 'rectangular_button.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget(
    this.title, {
    this.onTapped,
    this.badgeCount,
    this.isSelected = false,
    this.isMarked = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTapped;
  final bool isSelected;
  final int? badgeCount;
  // TODO: Implement this properly by allowing custom children
  final bool isMarked;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final textColor =
        isSelected ? Theme.of(context).colorScheme.onPrimary : color;
    final textStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        );

    return isSelected
        ? RectangularButton.flat(
            title: title,
            textStyle: textStyle,
            badgeCount: badgeCount,
            isMarked: isMarked,
            onPressed: () => onTapped?.call(),
          )
        : RectangularButton.outlined(
            title: title,
            textStyle: textStyle,
            badgeCount: badgeCount,
            isMarked: isMarked,
            onPressed: () => onTapped?.call(),
          );
  }
}
