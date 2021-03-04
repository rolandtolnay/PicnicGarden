import 'package:get_it/get_it.dart';

import 'auth_provider.dart';
import 'notification_provider.dart';
import 'order/order_builder.dart';
import 'order/order_provider.dart';
import 'order/order_status_provider.dart';
import 'phase_provider.dart';
import 'recipe_provider.dart';
import 'table_provider.dart';
import 'topic_provider.dart';

final providers = GetIt.instance;

void setupProviders() {
  providers.registerLazySingleton<AuthProvider>(
    () => FIRAuthProvider()..signIn(),
  );
  providers.registerLazySingleton<TopicProvider>(
    () => FIRTopicProvider(authProvider: providers())..fetchTopics(),
  );
  providers.registerLazySingleton<NotificationProvider>(
    () => FIRNotificationProvider(
      authProvider: providers(),
      topicProvider: providers(),
      tableProvider: providers(),
    )..requestPermissions(),
  );
  providers.registerLazySingleton<TableProvider>(
    () => FIRTableProvider()..fetchTables(),
  );

  providers.registerFactory<OrderProvider>(
    () => FIROrderProvider(notificationProvider: providers()),
  );
  providers.registerFactory<RecipeProvider>(
    () => FIRRecipeProvider()..fetchRecipes(),
  );
  providers.registerFactory<PhaseProvider>(
    () => FIRPhaseProvider()..fetchPhases(),
  );
  providers.registerFactory<OrderStatusProvider>(
    () => FIROrderStatusProvider()..fetchOrderStatusList(),
  );
  providers.registerFactory<OrderBuilder>(
    () => PGOrderBuilder(authProvider: providers()),
  );
}
