import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/build_context_ext_screen_size.dart';
import '../../common/max_width_container.dart';
import 'table_filter_provider.dart';

class TableFilterDialog extends StatelessWidget {
  const TableFilterDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => context.buildTableFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final provider = context.watch<TableFilterProvider>();

    var content = <Widget>[const Center(child: CircularProgressIndicator())];
    if (provider.isCompleted) {
      content = [
        const SizedBox(height: 24),
        Row(
          children: [
            const SizedBox(width: 16.0),
            const Icon(Icons.filter_alt),
            const SizedBox(width: 8.0),
            Text('Filter tables', style: textTheme.headline5),
          ],
        ),
        const SizedBox(height: 24),
        CheckboxListTile(
          title: Text('Hide empty tables'),
          controlAffinity: ListTileControlAffinity.leading,
          value: provider.hidingEmptyTables,
          onChanged: (value) {
            if (value == null) return;
            provider.setShowingEmptyTables(value);
          },
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            'Attributes',
            style: textTheme.headline6,
          ),
        ),
        const SizedBox(height: 8),
        ...provider.showingAttributes.entries
            .map(
              (entry) => CheckboxListTile(
                title: Text(entry.key.name),
                controlAffinity: ListTileControlAffinity.leading,
                value: entry.value,
                onChanged: (value) {
                  if (value == null) return;
                  provider.setAttributeShowing(value, attribute: entry.key);
                },
              ),
            )
            .toList(),
        const SizedBox(height: 24),
      ];
    }

    return MaxWidthContainer(
      maxWidth: kPhoneWidth,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: content,
          ),
        ),
      ),
    );
  }
}

extension on BuildContext {
  Widget buildTableFilterDialog() {
    return ChangeNotifierProvider.value(
      value: read<TableFilterProvider>(),
      child: TableFilterDialog(),
    );
  }
}
