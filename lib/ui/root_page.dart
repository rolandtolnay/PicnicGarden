import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import '../injection.dart';
import 'restaurant/restaurant_provider.dart';
import 'restaurant/restaurant_picker.dart';

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
