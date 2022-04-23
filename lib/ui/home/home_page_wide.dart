import 'package:flutter/material.dart';
import 'package:picnicgarden/model/table_entity.dart';
import 'package:provider/provider.dart';

import '../../provider/di.dart';
import '../../provider/restaurant_provider.dart';
import '../../provider/table_provider.dart';
import '../common/dialog_builder.dart';
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
              _buildTableHeader(context, table),
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

  Material _buildTableHeader(BuildContext context, TableEntity table) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final orderAddButton = IconButton(
      color: colorScheme.onPrimary,
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => DialogBuilder.of(context).buildOrderAdd(
            table: table,
          ),
        );
      },
      icon: const Icon(Icons.add, size: 32),
    );

    return Material(
      color: colorScheme.primary,
      elevation: 4,
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          TableNameWidget(
            table: table,
            showNotifications: false,
          ),
          Spacer(),
          orderAddButton,
          const SizedBox(width: 16.0),
        ],
      ),
    );
  }
}
