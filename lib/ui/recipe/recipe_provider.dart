import 'dart:collection';

import 'package:injectable/injectable.dart';

import '../../domain/model/recipe.dart';
import '../entity_provider.dart';
import '../restaurant/restaurant_provider.dart';

abstract class RecipeProvider extends EntityProvider {
  UnmodifiableListView<Recipe> get recipes;

  Future fetchRecipes();
}

@Injectable(as: RecipeProvider)
class FIRRecipeProvider extends FIREntityProvider<Recipe>
    implements RecipeProvider {
  FIRRecipeProvider({
    required RestaurantProvider restaurantProvider,
  }) : super(
          'recipes',
          Recipe.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        ) {
    fetchRecipes();
  }

  @override
  UnmodifiableListView<Recipe> get recipes => UnmodifiableListView(entities);

  @override
  Future fetchRecipes() async {
    await fetchEntities();
    entities.sort((a, b) => a.number.compareTo(b.number));
  }
}
