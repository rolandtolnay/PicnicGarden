import 'package:collection/collection.dart';

import '../../../domain/model/table_entity.dart';
import '../../../domain/model/table_status.dart';
import '../../../domain/model/table_status_change.dart';
import '../../../domain/pg_error.dart';
import '../../entity_provider.dart';
import '../../restaurant/restaurant_provider.dart';
import '../topic/notification_provider.dart';

abstract class TableProvider extends EntityProvider {
  UnmodifiableListView<TableEntity> get tables;
  Future fetchTables();

  TableEntity? get selectedTable;
  void selectTable(TableEntity table);

  Future<PGError?> setTableStatus(
    TableStatus? status, {
    required TableEntity table,
  });
}

class FIRTableProvider extends FIREntityProvider<TableEntity>
    implements TableProvider {
  String? _selectedTableId;

  final NotificationProvider _notificationProvider;

  FIRTableProvider({
    required RestaurantProvider restaurantProvider,
    required NotificationProvider notificationProvider,
  })  : _notificationProvider = notificationProvider,
        super(
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
  Future<PGError?> setTableStatus(
    TableStatus? status, {
    required TableEntity table,
  }) async {
    final updated = table.copyWith(status: status);
    final error = await postEntity(table.id, updated.toJson());
    if (error == null) {
      entities[entities.indexOf(table)] = updated;
      if (status != null) {
        final change = TableStatusChange(status, table);
        _notificationProvider.postForTableStatusChange(change);
      }
    }
    notifyListeners();
    return error;
  }
}
