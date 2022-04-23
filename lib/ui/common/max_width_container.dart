import 'package:flutter/material.dart';

import 'build_context_ext_screen_size.dart';

class MaxWidthContainer extends StatelessWidget {
  const MaxWidthContainer({
    Key? key,
    required this.child,
    this.maxWidth = kTabletWidth,
    this.maxHeight = double.infinity,
  }) : super(key: key);

  final Widget child;
  final double maxWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: child,
      ),
    );
  }
}
