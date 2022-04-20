import 'dart:collection';

import 'package:picnicgarden/model/restaurant.dart';
import 'package:picnicgarden/provider/entity_provider.dart';

abstract class RestaurantProvider extends EntityProvider {
  UnmodifiableListView<Restaurant> get restaurants;

  Future fetchRestaurants();

  Restaurant? get selectedRestaurant;
  void selectRestaurant(Restaurant restaurant);
}

class FIRRestaurantProvider extends FIREntityProvider<Restaurant>
    implements RestaurantProvider {
  Restaurant? _selectedRestaurant;

  FIRRestaurantProvider()
      : super('restaurants', Restaurant.fromJson);

  @override
  UnmodifiableListView<Restaurant> get restaurants =>
      UnmodifiableListView(entities);

  @override
  Future fetchRestaurants() async {
    await fetchEntities();
  }

  @override
  Restaurant? get selectedRestaurant => _selectedRestaurant;

  @override
  void selectRestaurant(Restaurant restaurant) {
    _selectedRestaurant = restaurant;
    notifyListeners();
  }
}
