import 'package:flutter/material.dart';

import 'build_context_ext_screen_size.dart';

class DialogCancelButton extends StatelessWidget {
  const DialogCancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.all(context.isTabletScreen ? 16.0 : 8),
        child: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('CANCEL'),
        ),
      ),
    );
  }
}
