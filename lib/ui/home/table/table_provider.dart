import 'dart:async';

import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/model/table_entity.dart';
import '../../../domain/model/table_status.dart';
import '../../../domain/pg_error.dart';
import '../../entity_provider.dart';
import '../../restaurant/restaurant_provider.dart';

abstract class TableProvider extends EntityProvider {
  UnmodifiableListView<TableEntity> get tables;
  Future fetchTables();

  TableEntity? get selectedTable;
  void selectTable(TableEntity table);

  Stream<TableEntity> get onTableStatusChanged;
  Future<ServiceError?> setTableStatus(
    TableStatus? status, {
    required TableEntity table,
  });
}

@LazySingleton(as: TableProvider)
class FIRTableProvider extends FIREntityProvider<TableEntity>
    implements TableProvider {
  final StreamController<TableEntity> tableStatusChangeController =
      StreamController.broadcast();
  String? _selectedTableId;

  FIRTableProvider({required RestaurantProvider restaurantProvider})
      : super(
          'tables',
          TableEntity.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        );

  @override
  UnmodifiableListView<TableEntity> get tables =>
      UnmodifiableListView(entities);

  @override
  TableEntity? get selectedTable =>
      entities.firstWhereOrNull((t) => t.id == _selectedTableId);

  @override
  Future fetchTables() async {
    await fetchEntities();
    entities.sort((a, b) => a.number.compareTo(b.number));
    if (_selectedTableId == null && tables.isNotEmpty) {
      selectTable(tables.first);
    }
  }

  @override
  void selectTable(TableEntity table) async {
    _selectedTableId = table.id;
    notifyListeners();
  }

  @override
  Future<ServiceError?> setTableStatus(
    TableStatus? status, {
    required TableEntity table,
  }) async {
    final updated = table.copyWith(status: status);
    final error = await postEntity(table.id, updated.toJson());
    if (error == null) {
      entities[entities.indexOf(table)] = updated;
      if (updated.status != null) tableStatusChangeController.add(updated);
    }
    notifyListeners();
    return error;
  }

  @override
  Stream<TableEntity> get onTableStatusChanged =>
      tableStatusChangeController.stream;
}
