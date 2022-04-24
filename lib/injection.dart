import 'package:get_it/get_it.dart';
import 'ui/restaurant/restaurant_provider.dart';

import 'ui/auth_provider.dart';
import 'ui/home/topic/notification_provider.dart';
import 'ui/order/order_add/order_builder.dart';
import 'ui/order/order_provider.dart';
import 'ui/order/order_list/order_status_provider.dart';
import 'ui/phase/phase_provider.dart';
import 'ui/recipe/recipe_provider.dart';
import 'ui/home/table/table_provider.dart';
import 'ui/home/topic/topic_provider.dart';

final di = GetIt.instance;

void configureDependencies() {
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
