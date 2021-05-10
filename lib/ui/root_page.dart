import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/notification_provider.dart';
import '../provider/order/order_provider.dart';
import '../provider/order/order_status_provider.dart';
import '../provider/phase_provider.dart';
import '../provider/di.dart';
import '../provider/recipe_provider.dart';
import '../provider/table_provider.dart';
import '../provider/topic_provider.dart';
import 'home/home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;

    return isAuthenticated
        ? MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: di<TableProvider>()),
              ChangeNotifierProvider(create: (_) => di<OrderProvider>()),
              ChangeNotifierProvider(
                create: (_) => di<RecipeProvider>(),
              ),
              ChangeNotifierProvider(create: (_) => di<PhaseProvider>()),
              ChangeNotifierProvider(create: (_) => di<RecipeProvider>()),
              ChangeNotifierProvider(create: (_) => di<OrderStatusProvider>()),
              ChangeNotifierProvider.value(value: di<TopicProvider>()),
              ChangeNotifierProvider.value(value: di<NotificationProvider>()),
            ],
            child: HomePage(),
          )
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
