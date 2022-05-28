import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:injectable/injectable.dart';

import '../model/order.dart';
import '../model/restaurant.dart';

part 'fir_collection_reference.g.dart';

@Collection<Restaurant>('restaurants')
@Collection<Order>('restaurants/*/orders')
final _restaurantsRef = RestaurantCollectionReference();

OrderCollectionReference _ordersRef(String restaurant) =>
    _restaurantsRef.doc(restaurant).orders;

@Injectable()
class FirCollectionReference {
  OrderCollectionReference orders(Restaurant restaurant) =>
      _ordersRef(restaurant.name);
}
