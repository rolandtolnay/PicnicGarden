import 'dart:collection';

import '../model/phase.dart';
import 'entity_provider.dart';

abstract class PhaseProvider extends EntityProvider {
  UnmodifiableListView<Phase> get phases;

  Future fetchPhases();
}

class FIRPhaseProvider extends FIREntityProvider<Phase>
    implements PhaseProvider {
  FIRPhaseProvider() : super('phases', (json) => Phase.fromJson(json));

  @override
  UnmodifiableListView<Phase> get phases => UnmodifiableListView(entities);

  @override
  Future fetchPhases() async {
    await fetchEntities();
    entities.sort((a, b) => a.number.compareTo(b.number));
  }
}
