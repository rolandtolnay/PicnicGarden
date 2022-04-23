import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/table_entity.dart';
import '../../provider/di.dart';
import '../../provider/order/order_builder.dart';
import '../../provider/order/order_provider.dart';
import '../../provider/order/order_status_provider.dart';
import '../../provider/phase_provider.dart';
import '../../provider/recipe_provider.dart';
import '../order/order_add/order_add_dialog.dart';

class DialogBuilder {
  final BuildContext _context;
  DialogBuilder._(this._context);

  static DialogBuilder of(BuildContext context) => DialogBuilder._(context);

  Widget buildOrderAdd({required TableEntity table}) {
    final orderStatusProvider = _context.read<OrderStatusProvider>();

    return Provider(
      create: (_) => di<OrderBuilder>()
        ..setTable(table)
        ..setOrderStatus(orderStatusProvider.orderStatusList.first),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: _context.read<RecipeProvider>(),
          ),
          ChangeNotifierProvider.value(
            value: _context.read<PhaseProvider>(),
          ),
          ChangeNotifierProvider.value(
            value: _context.read<OrderProvider>(),
          )
        ],
        child: OrderAddDialog(),
      ),
    );
  }
}
