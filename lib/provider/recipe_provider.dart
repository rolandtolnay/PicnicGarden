import 'dart:collection';

import '../model/recipe.dart';
import 'entity_provider.dart';

abstract class RecipeProvider extends EntityProvider {
  UnmodifiableListView<Recipe> get recipes;

  Future fetchRecipes();
}

class FIRRecipeProvider extends FIREntityProvider<Recipe>
    implements RecipeProvider {
  FIRRecipeProvider() : super('recipes', (json) => Recipe.fromJson(json));

  @override
  UnmodifiableListView<Recipe> get recipes => UnmodifiableListView(entities);

  @override
  Future fetchRecipes() async {
    await fetchEntities();
    entities.sort((a, b) => a.name.compareTo(b.name));
  }
}
