import 'dart:collection';

import 'package:picnicgarden/domain/model/table_status.dart';
import 'package:picnicgarden/domain/pg_error.dart';

import '../../../domain/model/table_entity.dart';
import '../../entity_provider.dart';
import '../../restaurant/restaurant_provider.dart';

abstract class TableProvider extends EntityProvider {
  UnmodifiableListView<TableEntity> get tables;
  Future fetchTables();

  TableEntity? get selectedTable;
  void selectTable(TableEntity table);

  Future<PGError?> setTableStatus(
    TableStatus status, {
    required TableEntity table,
  });
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

  @override
  Future<PGError?> setTableStatus(
    TableStatus status, {
    required TableEntity table,
  }) async {
    return postEntity(table.id, table.copyWith(status: status).toJson());
  }
}
