import 'package:flutter/material.dart';
import 'package:picnicgarden/ui/home/table/table_filter_provider.dart';
import 'package:provider/provider.dart';

class TableFilterDialog extends StatelessWidget {
  const TableFilterDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TableFilterProvider>(),
        child: TableFilterDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TableFilterProvider>();
    return AlertDialog(
      title: Text('Filter tables'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CheckboxListTile(
          title: Text('Hide empty tables'),
          controlAffinity: ListTileControlAffinity.leading,
          value: !provider.showingEmptyTables,
          onChanged: (value) {
            if (value == null) return;
            provider.setShowingEmptyTables(!value);
          },
        )
      ]),
    );
  }
}
