import 'package:flutter/material.dart';

import '../../domain/model/order.dart';

extension SnackBarBuilder on SnackBar {
  static SnackBar orderSucces(Order order, BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textStyle = textTheme.subtitle1?.copyWith(
      fontWeight: FontWeight.bold,
      color: isDarkMode ? colorScheme.onInverseSurface : colorScheme.onPrimary,
    );

    return SnackBar(
      duration: Duration(milliseconds: 2000),
      behavior: SnackBarBehavior.floating,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ADDED'),
          const SizedBox(height: 8.0),
          Text(
            order.userFriendlyDescription,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
