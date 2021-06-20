import 'package:get_it/get_it.dart';
import 'package:picnicgarden/provider/restaurant_provider.dart';

import 'auth_provider.dart';
import 'notification_provider.dart';
import 'order/order_builder.dart';
import 'order/order_provider.dart';
import 'order/order_status_provider.dart';
import 'phase_provider.dart';
import 'recipe_provider.dart';
import 'table_provider.dart';
import 'topic_provider.dart';

final di = GetIt.instance;

void setupProviders() {
  di.registerLazySingleton<AuthProvider>(
    () => FIRAuthProvider()..signIn(),
  );
  di.registerLazySingleton<TopicProvider>(
    () => FIRTopicProvider(
      authProvider: di(),
      restaurantProvider: di(),
    )..fetchTopics(),
  );
  di.registerLazySingleton<NotificationProvider>(
    () => FIRNotificationProvider(
      authProvider: di(),
      topicProvider: di(),
      tableProvider: di(),
      restaurantProvider: di(),
    )..requestPermissions(),
  );
  di.registerLazySingleton<TableProvider>(
    () => FIRTableProvider(restaurantProvider: di())..fetchTables(),
  );
  di.registerLazySingleton<RestaurantProvider>(
    () => FIRRestaurantProvider()..fetchRestaurants(),
  );

  di.registerFactory<OrderProvider>(
    () => FIROrderProvider(
      notificationProvider: di(),
      restaurantProvider: di(),
    ),
  );
  di.registerFactory<RecipeProvider>(
    () => FIRRecipeProvider(restaurantProvider: di())..fetchRecipes(),
  );
  di.registerFactory<PhaseProvider>(
    () => FIRPhaseProvider(restaurantProvider: di())..fetchPhases(),
  );
  di.registerFactory<OrderStatusProvider>(
    () => FIROrderStatusProvider(
      restaurantProvider: di(),
    )..fetchOrderStatusList(),
  );
  di.registerFactory<OrderBuilder>(
    () => PGOrderBuilder(authProvider: di()),
  );
}
