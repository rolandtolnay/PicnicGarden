import 'package:flutter/material.dart';
import '../provider/notification_provider.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/order/order_provider.dart';
import '../provider/order/order_status_provider.dart';
import '../provider/phase_provider.dart';
import '../provider/providers.dart';
import '../provider/recipe_provider.dart';
import '../provider/table_provider.dart';
import 'home/home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;

    return isAuthenticated
        ? MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => providers<TableProvider>()),
              ChangeNotifierProvider(create: (_) => providers<OrderProvider>()),
              ChangeNotifierProvider(
                create: (_) => providers<RecipeProvider>(),
              ),
              ChangeNotifierProvider(create: (_) => providers<PhaseProvider>()),
              ChangeNotifierProvider(
                  create: (_) => providers<RecipeProvider>()),
              ChangeNotifierProvider(
                  create: (_) => providers<OrderStatusProvider>()),
              ChangeNotifierProvider.value(
                value: providers<NotificationProvider>(),
              ),
            ],
            child: HomePage(),
          )
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
