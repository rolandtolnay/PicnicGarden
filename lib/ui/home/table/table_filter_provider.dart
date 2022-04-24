import '../../../domain/model/attribute.dart';
import '../../entity_provider.dart';
import '../../restaurant/restaurant_provider.dart';

abstract class TableFilterProvider extends EntityProvider {
  bool get showingEmptyTables;
  void setShowingEmptyTables(bool showing);

  Future fetchAttributes();
  Map<Attribute, bool> get showingAttributes;
  void setAttributeShowing(bool showing, {required Attribute attribute});

  bool get hasFiltersEnabled;
}

extension Convenience on TableFilterProvider {
  Iterable<Attribute> get enabledAttributes {
    return showingAttributes.entries.where((e) => e.value).map((e) => e.key);
  }
}

class TableFilterProviderImpl extends FIREntityProvider<Attribute>
    implements TableFilterProvider {
  TableFilterProviderImpl({
    required RestaurantProvider restaurantProvider,
  }) : super(
          'attributes',
          Attribute.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        );

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
  bool get hasFiltersEnabled =>
      !_showingEmptyTables ||
      _showingAttributes.values.any((showing) => !showing);
}
