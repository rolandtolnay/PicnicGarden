import 'dart:collection';

import 'package:flutter/material.dart';

import '../model/recipe.dart';
import 'entity_provider.dart';

abstract class RecipeProvider extends ChangeNotifier {
  UnmodifiableListView<Recipe> get recipes;

  Future fetchRecipes();
}

class FIRRecipeProvider extends FIREntityProvider<Recipe>
    implements RecipeProvider {
  FIRRecipeProvider() : super('recipes', (json) => Recipe.fromJson(json));

  @override
  UnmodifiableListView<Recipe> get recipes => super.entities;

  @override
  Future fetchRecipes() async {
    await super.fetchEntities();
  }
}
