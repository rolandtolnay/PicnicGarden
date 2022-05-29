import 'package:flutter/material.dart';

import '../../../../domain/model/table_entity.dart';
import '../../../common/text_icon_button.dart';
import '../../../order/order_list/order_group_button.dart';
import '../table_status_picker_sheet.dart';
import 'table_status_ui_ext.dart';

class TableActionBar extends StatelessWidget {
  final TableEntity table;

  const TableActionBar({required this.table, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: 44,
      color: table.status?.backgroundColor ?? colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextIconButton(
            icon: table.status.icon,
            title: table.status.title,
            onPressed: () => TableStatusPickerSheet.show(context, table: table),
          ),
          OrderGroupButton(table: table, hideLabel: false),
        ],
      ),
    );
  }
}
