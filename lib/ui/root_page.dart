import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/di.dart';
import '../provider/restaurant_provider.dart';
import 'home/restaurant_picker.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;

    return isAuthenticated
        ? ChangeNotifierProvider.value(
            value: di<RestaurantProvider>(),
            child: RestaurantPicker(),
          )
        : const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
