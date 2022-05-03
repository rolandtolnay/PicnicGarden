import 'dart:collection';

import '../../../domain/model/table_status.dart';
import '../../entity_provider.dart';
import '../../restaurant/restaurant_provider.dart';

abstract class TableStatusProvider extends EntityProvider {
  UnmodifiableListView<TableStatus> get tableStatusList;

  Future fetchTableStatusList();
}

class FIRTableStatusProvider extends FIREntityProvider<TableStatus>
    implements TableStatusProvider {
  FIRTableStatusProvider({
    required RestaurantProvider restaurantProvider,
  }) : super(
          'tableStatus',
          TableStatus.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        );

  @override
  UnmodifiableListView<TableStatus> get tableStatusList =>
      UnmodifiableListView(entities);

  @override
  Future fetchTableStatusList() async {
    await fetchEntities();
    entities.sort((a, b) => a.flow.compareTo(b.flow));
  }
}
