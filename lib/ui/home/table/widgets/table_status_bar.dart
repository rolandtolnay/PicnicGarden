import 'package:flutter/material.dart';
import 'package:picnicgarden/domain/model/table_status.dart';

import '../../../../domain/model/table_entity.dart';
import '../table_status_picker.dart';

class TableStatusBar extends StatelessWidget {
  final TableEntity table;

  const TableStatusBar({required this.table, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () => TableStatusPicker.show(context, table: table),
      child: Container(
        height: 44,
        color: table.status?.backgroundColor ?? colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(table.status.icon, color: colorScheme.onPrimary, size: 16),
            SizedBox(width: 8.0),
            Text(
              table.status.title,
              style:
                  textTheme.bodyText2?.copyWith(color: colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

extension on TableStatus? {
  String get title => this?.name.toUpperCase() ?? 'SET TABLE STATUS';

  IconData get icon => this == null ? Icons.threesixty : Icons.tour;
}
