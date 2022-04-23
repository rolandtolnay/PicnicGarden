import 'dart:collection';

import '../model/table_entity.dart';
import 'entity_provider.dart';
import 'restaurant_provider.dart';

abstract class TableProvider extends EntityProvider {
  UnmodifiableListView<TableEntity> get tables;
  Future fetchTables();

  TableEntity? get selectedTable;
  void selectTable(TableEntity table);
}

class FIRTableProvider extends FIREntityProvider<TableEntity>
    implements TableProvider {
  TableEntity? _selectedTable;

  FIRTableProvider({
    required RestaurantProvider restaurantProvider,
  }) : super(
          'tables',
          TableEntity.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        );

  @override
  UnmodifiableListView<TableEntity> get tables =>
      UnmodifiableListView(entities);

  @override
  TableEntity? get selectedTable => _selectedTable;

  @override
  Future fetchTables() async {
    await fetchEntities();
    entities.sort((a, b) => a.number.compareTo(b.number));
    if (_selectedTable == null && tables.isNotEmpty) {
      selectTable(tables.first);
    }
  }

  @override
  void selectTable(TableEntity table) async {
    _selectedTable = table;
    notifyListeners();
  }
}
