import 'package:get_it/get_it.dart';
import 'package:picnicgarden/provider/notification_provider.dart';
import 'package:picnicgarden/provider/order/order_builder.dart';
import 'package:picnicgarden/provider/order/order_provider.dart';
import 'package:picnicgarden/provider/order/order_status_provider.dart';
import 'package:picnicgarden/provider/phase_provider.dart';
import 'package:picnicgarden/provider/recipe_provider.dart';
import 'package:picnicgarden/provider/table_provider.dart';
import 'package:picnicgarden/provider/topic_provider.dart';

import 'auth_provider.dart';

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
