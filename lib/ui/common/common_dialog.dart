import 'package:flutter/material.dart';
import 'package:picnicgarden/ui/common/build_context_ext_screen_size.dart';

import 'max_width_container.dart';

class CommonDialog extends StatelessWidget {
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final Widget? child;

  const CommonDialog({
    this.maxWidth = kTabletWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inset = EdgeInsets.symmetric(horizontal: 16.0, vertical: 24);
    return MaxWidthContainer(
      maxWidth: maxWidth,
      child: Dialog(
        elevation: 2,
        insetPadding: inset,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
