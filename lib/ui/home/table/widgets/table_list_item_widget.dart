import 'package:flutter/material.dart';

import '../../../common/rectangular_button.dart';

class TableListItemWidget extends StatelessWidget {
  const TableListItemWidget(
    this.title, {
    this.onTapped,
    this.badgeCount,
    this.isSelected = false,
    this.isMarked = false,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTapped;
  final bool isSelected;
  final int? badgeCount;
  // TODO: Implement this properly by allowing custom children
  final bool isMarked;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final textStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        );

    return RectangularButton.outlined(
      title: title,
      textStyle: textStyle,
      badgeCount: badgeCount,
      isMarked: isMarked,
      borderColor: isSelected ? color : backgroundColor,
      onPressed: () => onTapped?.call(),
      backgroundColor: backgroundColor,
    );
  }
}
