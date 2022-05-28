import 'dart:collection';

import 'package:injectable/injectable.dart';

import '../../domain/model/phase.dart';
import '../entity_provider.dart';
import '../restaurant/restaurant_provider.dart';

abstract class PhaseProvider extends EntityProvider {
  UnmodifiableListView<Phase> get phases;

  Future fetchPhases();
}

@Injectable(as: PhaseProvider)
class FIRPhaseProvider extends FIREntityProvider<Phase>
    implements PhaseProvider {
  FIRPhaseProvider({
    required RestaurantProvider restaurantProvider,
  }) : super(
          'phases',
          Phase.fromJson,
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
