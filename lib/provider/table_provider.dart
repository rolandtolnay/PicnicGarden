import 'dart:collection';

import 'package:picnicgarden/logic/api_response.dart';

import '../model/table.dart';
import 'entity_provider.dart';
import 'notification_provider.dart';

abstract class TableProvider extends EntityProvider {
  UnmodifiableListView<Table> get tables;
  Future fetchTables();

  Table get selectedTable;
  void selectTable(Table table);
}

class FIRTableProvider extends FIREntityProvider<Table>
    implements TableProvider {
  Table _selectedTable;

  FIRTableProvider() : super('tables', (json) => Table.fromJson(json));

  @override
  UnmodifiableListView<Table> get tables => UnmodifiableListView(entities);

  @override
  Table get selectedTable => _selectedTable;

  @override
  Future fetchTables() async {
    await fetchEntities();
    entities.sort((a, b) => a.number.compareTo(b.number));
    if (_selectedTable == null && tables.isNotEmpty) {
      selectTable(tables.first);
    }
  }

  @override
  void selectTable(Table table) async {
    _selectedTable = table;
    notifyListeners();
  }
}
