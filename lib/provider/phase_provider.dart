import 'dart:collection';

import '../model/phase.dart';
import 'entity_provider.dart';
import 'restaurant_provider.dart';

abstract class PhaseProvider extends EntityProvider {
  UnmodifiableListView<Phase> get phases;

  Future fetchPhases();
}

class FIRPhaseProvider extends FIREntityProvider<Phase>
    implements PhaseProvider {
  FIRPhaseProvider({
    required RestaurantProvider restaurantProvider,
  }) : super(
          'phases',
          (json) => Phase.fromJson(json),
          restaurant: restaurantProvider.selectedRestaurant,
        );

  @override
  UnmodifiableListView<Phase> get phases => UnmodifiableListView(entities);

  @override
  Future fetchPhases() async {
    await fetchEntities();
    entities.sort((a, b) => a.number.compareTo(b.number));
  }
}
