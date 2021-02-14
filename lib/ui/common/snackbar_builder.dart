import 'package:flutter/material.dart';

import '../../model/order.dart';

extension SnackBarBuilder on SnackBar {
  static SnackBar orderSucces(Order order, BuildContext context) {
    final textStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w500,
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
            '${order.userFriendlyDescription}',
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
