import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:picnicgarden/domain/cache/order_cache.dart';

import '../../domain/model/restaurant.dart';
import '../entity_provider.dart';

abstract class RestaurantProvider extends EntityProvider {
  UnmodifiableListView<Restaurant> get restaurants;

  Future fetchRestaurants();

  Restaurant? get selectedRestaurant;
  void selectRestaurant(Restaurant restaurant);
}

@LazySingleton(as: RestaurantProvider)
class FIRRestaurantProvider extends FIREntityProvider<Restaurant>
    implements RestaurantProvider {
  final OrderCache _orderCache;

  Restaurant? _selectedRestaurant;

  FIRRestaurantProvider(this._orderCache)
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
    _orderCache.listenOnOrderUpdates(restaurant);
    notifyListeners();
  }
}
