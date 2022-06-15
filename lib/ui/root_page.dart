import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'restaurant/restaurant_picker.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select<AuthProvider, bool>(
      (p) => p.isAuthenticated,
    );

    const loading = Scaffold(body: Center(child: CircularProgressIndicator()));
    return isAuthenticated ? RestaurantPicker() : loading;
  }
}
