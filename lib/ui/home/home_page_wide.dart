import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:picnicgarden/ui/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../domain/model/table_entity.dart';
import '../../injection.dart';
import '../order/order_add/order_add_dialog.dart';
import '../order/order_list/order_list_dialog.dart';
import '../order/order_list/order_list_page.dart';
import '../order/order_provider.dart';
import '../restaurant/restaurant_provider.dart';
import 'table/table_filter_dialog.dart';
import 'table/table_filter_provider.dart';
import 'table/table_name_widget.dart';
import 'table/table_provider.dart';

const _maxTableWidth = 360;

class HomePageWide extends StatelessWidget {
  const HomePageWide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _HomePageWideBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final filterProvider = context.watch<TableFilterProvider>();
    final themeProvider = context.watch<ThemeModeProvider>();

    final badgeColor =
        isDarkMode ? colorScheme.secondary : colorScheme.secondaryContainer;
    final filterButton = Badge(
      showBadge: filterProvider.filterCount > 0,
      toAnimate: false,
      badgeColor: badgeColor,
      position: BadgePosition.topStart(top: 4, start: 12),
      padding: const EdgeInsets.all(6.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(primary: colorScheme.onPrimary),
        onPressed: () => TableFilterDialog.show(context),
        icon: Icon(Icons.filter_alt),
        label: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'FILTER TABLES',
                style: textTheme.subtitle1?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              if (filterProvider.filterCount > 0)
                TextSpan(
                  text: ' (${filterProvider.filterCount})',
                  style: textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: badgeColor,
                  ),
                )
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );

    final restaurant = di<RestaurantProvider>().selectedRestaurant;
    return AppBar(
      title: Text(restaurant?.name ?? ''),
      leadingWidth: 240,
      automaticallyImplyLeading: false,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: filterButton,
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            themeProvider.setThemeMode(
              isDarkMode ? ThemeMode.light : ThemeMode.dark,
            );
          },
          icon: Icon(isDarkMode ? Icons.bedtime : Icons.brightness_5),
          label: Text(isDarkMode ? 'DARK THEME' : 'LIGHT THEME'),
          style: TextButton.styleFrom(primary: colorScheme.onPrimary),
        )
      ],
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
    // If showing empty tables, they don't need to be filtered
    if (filterProvider.showingEmptyTables) return toList();
    // If hiding empty tables, we have to apply attribute filter
    // before deciding if they are empty or not
    final enabled = filterProvider.enabledAttributes;
    // Return tables that have at least one order with an enabled attribute
    return where(
      (table) => orderProvider
          .ordersForTable(table)
          .filteredBy(enabledAttributes: enabled)
          .isNotEmpty,
    ).toList();
  }
}
