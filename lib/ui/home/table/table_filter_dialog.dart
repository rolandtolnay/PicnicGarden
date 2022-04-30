import 'package:flutter/material.dart';
import 'package:picnicgarden/ui/common/dialog_title.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/attribute.dart';
import '../../common/build_context_ext_screen_size.dart';
import '../../common/common_dialog.dart';
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
        const DialogTitle(text: 'Filter tables', icon: Icons.filter_alt),
        CheckboxListTile(
          title: Text('Show empty tables'),
          controlAffinity: ListTileControlAffinity.leading,
          value: provider.showingEmptyTables,
          onChanged: (value) {
            if (value == null) return;
            provider.setShowingEmptyTables(value);
          },
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            'Attributes',
            style: textTheme.headline6!.copyWith(fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(height: 8),
        ...provider.showingAttributes.entries
            .map((entry) => _buildAttributeCheckbox(entry, provider))
            .toList(),
        const SizedBox(height: 24),
      ];
    }

    return CommonDialog(
      maxWidth: kPhoneWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: content,
        ),
      ),
    );
  }

  CheckboxListTile _buildAttributeCheckbox(
    MapEntry<Attribute, bool> entry,
    TableFilterProvider provider,
  ) {
    return CheckboxListTile(
      title: Text(entry.key.name),
      controlAffinity: ListTileControlAffinity.leading,
      value: entry.value,
      onChanged: (value) {
        if (value == null) return;
        provider.setAttributeShowing(value, attribute: entry.key);
      },
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
