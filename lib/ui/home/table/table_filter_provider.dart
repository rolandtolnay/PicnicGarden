import 'package:injectable/injectable.dart';

import '../../../domain/model/attribute.dart';
import '../../entity_provider.dart';
import '../../restaurant/restaurant_provider.dart';

abstract class TableFilterProvider extends EntityProvider {
  bool get showingEmptyTables;
  void setShowingEmptyTables(bool showing);

  Future fetchAttributes();
  Map<Attribute, bool> get showingAttributes;
  void setAttributeShowing(bool showing, {required Attribute attribute});

  int get filterCount;
}

extension Convenience on TableFilterProvider {
  Iterable<Attribute> get enabledAttributes {
    return showingAttributes.entries.where((e) => e.value).map((e) => e.key);
  }
}

@LazySingleton(as: TableFilterProvider)
class TableFilterProviderImpl extends FIREntityProvider<Attribute>
    implements TableFilterProvider {
  TableFilterProviderImpl({
    required RestaurantProvider restaurantProvider,
  }) : super(
          'attributes',
          Attribute.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        ) {
    fetchAttributes();
  }

  bool _showingEmptyTables = true;
  Map<Attribute, bool> _showingAttributes = {};

  @override
  bool get showingEmptyTables => _showingEmptyTables;

  @override
  void setShowingEmptyTables(bool showing) {
    _showingEmptyTables = showing;
    notifyListeners();
  }

  @override
  Future fetchAttributes() async {
    await fetchEntities();
    _showingAttributes = entities.fold(<Attribute, bool>{}, (map, element) {
      map[element] = true;
      return map;
    });
  }

  @override
  Map<Attribute, bool> get showingAttributes => _showingAttributes;

  @override
  void setAttributeShowing(bool showing, {required Attribute attribute}) {
    _showingAttributes[attribute] = showing;
    notifyListeners();
  }

  @override
  int get filterCount {
    var count = 0;
    if (!showingEmptyTables) count++;
    count += _showingAttributes.values.where((showing) => !showing).length;
    return count;
  }
}
