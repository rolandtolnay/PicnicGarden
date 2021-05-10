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

final di = GetIt.instance;

void setupProviders() {
  di.registerLazySingleton<AuthProvider>(
    () => FIRAuthProvider()..signIn(),
  );
  di.registerLazySingleton<TopicProvider>(
    () => FIRTopicProvider(authProvider: di())..fetchTopics(),
  );
  di.registerLazySingleton<NotificationProvider>(
    () => FIRNotificationProvider(
      authProvider: di(),
      topicProvider: di(),
      tableProvider: di(),
    )..requestPermissions(),
  );
  di.registerLazySingleton<TableProvider>(
    () => FIRTableProvider()..fetchTables(),
  );

  di.registerFactory<OrderProvider>(
    () => FIROrderProvider(notificationProvider: di()),
  );
  di.registerFactory<RecipeProvider>(
    () => FIRRecipeProvider()..fetchRecipes(),
  );
  di.registerFactory<PhaseProvider>(
    () => FIRPhaseProvider()..fetchPhases(),
  );
  di.registerFactory<OrderStatusProvider>(
    () => FIROrderStatusProvider()..fetchOrderStatusList(),
  );
  di.registerFactory<OrderBuilder>(
    () => PGOrderBuilder(authProvider: di()),
  );
}
