import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:picnicgarden/ui/home/table/table_filter_dialog.dart';
import 'package:picnicgarden/ui/home/table/table_filter_provider.dart';
import 'package:picnicgarden/ui/order/order_provider.dart';
import 'package:provider/provider.dart';

import '../../domain/model/table_entity.dart';
import '../../injection.dart';
import '../restaurant/restaurant_provider.dart';
import 'table/table_provider.dart';
import '../order/order_add/order_add_dialog.dart';
import '../order/order_list/order_list_dialog.dart';
import '../order/order_list/order_list_page.dart';
import 'table/table_name_widget.dart';

const _maxTableWidth = 360;

class HomePageWide extends StatelessWidget {
  const HomePageWide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: di<TableFilterProvider>(),
      builder: (context, _) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _HomePageWideBody(),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final restaurant = di<RestaurantProvider>().selectedRestaurant;

    final provider = context.watch<TableFilterProvider>();
    final filterButton = Badge(
      showBadge: provider.hasFiltersEnabled,
      toAnimate: false,
      badgeColor: Theme.of(context).colorScheme.secondary,
      position: BadgePosition.topStart(top: 12, start: 12),
      padding: const EdgeInsets.all(6.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          primary: Colors.white,
          textStyle: textTheme.subtitle1,
        ),
        onPressed: () => TableFilterDialog.show(context),
        icon: Icon(Icons.filter_alt),
        label: Text('FILTER TABLES'),
      ),
    );

    return AppBar(
      backgroundColor: Colors.black87,
      title: Text(restaurant?.name ?? ''),
      leadingWidth: 168,
      leading: filterButton,
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
    final tables = tableProvider.tables.applyingFilter(
      filterProvider: context.watch<TableFilterProvider>(),
      orderProvider: context.watch<OrderProvider>(),
    );
    return GridView.count(
      crossAxisCount: (screenWidth / _maxTableWidth).round(),
      childAspectRatio: 0.7,
      children: tables.map(
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
      onPressed: () => OrderAddDialog.show(context, table: table),
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
            onTapped: () => OrderListDialog.show(context, table: table),
          ),
          Spacer(),
          orderAddButton,
          const SizedBox(width: 16.0),
        ],
      ),
    );
  }
}

extension on Iterable<TableEntity> {
  List<TableEntity> applyingFilter({
    required TableFilterProvider filterProvider,
    required OrderProvider orderProvider,
  }) {
    if (!filterProvider.hidingEmptyTables) return toList();
    return where((t) => orderProvider.ordersForTable(t).isNotEmpty).toList();
  }
}
