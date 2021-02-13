import 'dart:collection';

import '../model/table.dart';
import 'entity_provider.dart';

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
  UnmodifiableListView<Table> get tables => super.entities;

  @override
  Table get selectedTable => _selectedTable;

  @override
  Future fetchTables() async {
    await super.fetchEntities();
    if (_selectedTable == null && tables.isNotEmpty) {
      selectTable(tables.first);
    }
  }

  @override
  void selectTable(Table table) {
    _selectedTable = table;
    notifyListeners();
  }
}
