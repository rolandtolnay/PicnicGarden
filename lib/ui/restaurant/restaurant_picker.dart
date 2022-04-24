import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../domain/pg_error.dart';
import '../../domain/model/restaurant.dart';
import 'restaurant_provider.dart';
import '../common/empty_refreshable.dart';
import '../home/home_page.dart';

class RestaurantPicker extends StatelessWidget {
  const RestaurantPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _RestaurantPickerBody());
  }
}

class _RestaurantPickerBody extends StatelessWidget {
  const _RestaurantPickerBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<RestaurantProvider>();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      provider.response.error?.showInDialog(context);
    });
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.restaurants.isEmpty) {
      return EmptyRefreshable(
        'No tables found.',
        onRefresh: provider.fetchRestaurants,
      );
    }

    // TODO: Remove after development finished
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   Future.delayed(
    //     Duration(milliseconds: 500),
    //     () => _selectRestaurant(provider.restaurants[1], context),
    //   );
    // });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          child: Text(
            'Choose a restaurant',
            style: textTheme.headline3,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 64),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: provider.restaurants.map((restaurant) {
            return InkWell(
              onTap: () => _selectRestaurant(restaurant, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      restaurant.name.toUpperCase(),
                      style: textTheme.headline5,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Image.asset(
                    'assets/images/${restaurant.imageName}',
                    height: 120,
                    width: 120,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _selectRestaurant(Restaurant restaurant, BuildContext context) {
    final provider = context.read<RestaurantProvider>();

    provider.selectRestaurant(restaurant);
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomePage(),
        fullscreenDialog: true,
      ),
    );
  }
}
