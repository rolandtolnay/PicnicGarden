import 'package:meta/meta.dart';

import '../../model/order.dart';
import '../../model/order_status.dart';
import '../../model/phase.dart';
import '../../model/recipe.dart';
import '../../model/table.dart';
import '../auth_provider.dart';

abstract class OrderBuilder {
  void setTable(Table table);
  void setRecipe(Recipe recipe);
  void setPhase(Phase phase);
  void setOrderStatus(OrderStatus orderStatus);

  Order makeOrder();
}

class PGOrderBuilder implements OrderBuilder {
  final AuthProvider _authProvider;
  Table _table;
  Recipe _recipe;
  Phase _phase;
  OrderStatus _orderStatus;

  PGOrderBuilder({@required AuthProvider authProvider})
      : _authProvider = authProvider;

  @override
  Order makeOrder() {
    if (_table == null ||
        _recipe == null ||
        _phase == null ||
        _orderStatus == null) return null;

    return Order(
      recipe: _recipe,
      table: _table,
      currentStatus: _orderStatus,
      phase: _phase,
      createdBy: _authProvider.userId,
    );
  }

  @override
  void setOrderStatus(OrderStatus orderStatus) {
    _orderStatus = orderStatus;
  }

  @override
  void setPhase(Phase phase) {
    _phase = phase;
  }

  @override
  void setRecipe(Recipe recipe) {
    _recipe = recipe;
  }

  @override
  void setTable(Table table) {
    _table = table;
  }
}
