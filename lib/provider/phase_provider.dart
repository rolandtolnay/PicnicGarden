import 'dart:collection';

import 'package:flutter/material.dart';

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
  UnmodifiableListView<Phase> get phases => super.entities;

  @override
  Future fetchPhases() async {
    await super.fetchEntities();
  }
}
