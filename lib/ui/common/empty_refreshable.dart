import 'package:flutter/material.dart';

class EmptyRefreshable extends StatelessWidget {
  const EmptyRefreshable(
    this.text, {
    required this.onRefresh,
    Key? key,
  }) : super(key: key);

  final String text;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh as Future<void> Function(),
      child: Stack(
        children: [
          ListView(),
          Center(
            child: Text(text, style: Theme.of(context).textTheme.subtitle1),
          ),
        ],
      ),
    );
  }
}
