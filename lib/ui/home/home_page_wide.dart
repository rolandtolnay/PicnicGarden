import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/di.dart';
import '../../provider/restaurant_provider.dart';
import '../../provider/table_provider.dart';
import '../order/order_list/order_list_page.dart';
import 'widgets/table_name_widget.dart';

const _maxTableWidth = 360;

class HomePageWide extends StatelessWidget {
  const HomePageWide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurant = di<RestaurantProvider>().selectedRestaurant;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(restaurant?.name ?? ''),
      ),
      body: _HomePageWideBody(),
    );
  }
}

class _HomePageWideBody extends StatelessWidget {
  const _HomePageWideBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableProvider = context.watch<TableProvider>();
    if (tableProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return GridView.count(
      crossAxisCount: (screenWidth / _maxTableWidth).round(),
      childAspectRatio: 0.7,
      children: tableProvider.tables.map(
        (table) {
          return Column(
            children: [
              TableNameWidget(table: table, showNotifications: false),
              Expanded(
                child: OrderListPage(
                  table: table,
                  showTimer: false,
                  scrollable: false,
                ),
              ),
            ],
          );
        },
      ).toList(),
    );
  }
}
