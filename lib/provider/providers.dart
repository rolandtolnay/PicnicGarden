import 'package:get_it/get_it.dart';
import 'package:picnicgarden/provider/order_provider.dart';
import 'package:picnicgarden/provider/recipe_provider.dart';
import 'package:picnicgarden/provider/table_provider.dart';

import 'auth_provider.dart';

final providers = GetIt.instance;

void setupProviders() {
  providers.registerFactory<AuthProvider>(
    () => FIRAuthProvider()..signIn(),
  );
  providers.registerFactory<TableProvider>(
    () => FIRTableProvider()..fetchTables(),
  );
  providers.registerFactory<OrderProvider>(
    () => FIROrderProvider()..fetchOrders(),
  );
  providers.registerFactory<RecipeProvider>(
    () => FIRRecipeProvider()..fetchRecipes(),
  );
}
