import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:injectable/injectable.dart';
import 'package:picnicgarden/domain/model/restaurant.dart';

import '../model/order.dart';

part 'fir_collection_reference.g.dart';

@Collection<Restaurant>('restaurants')
@Collection<Order>('restaurants/*/orders')
final _restaurantsRef = RestaurantCollectionReference();

OrderCollectionReference _ordersRef(String restaurant) =>
    _restaurantsRef.doc(restaurant).orders;

@Injectable()
class FirCollectionReference {
  OrderCollectionReference orders(String restaurant) => _ordersRef(restaurant);
}
