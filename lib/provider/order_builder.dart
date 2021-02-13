import 'package:picnicgarden/model/order.dart';
import 'package:picnicgarden/model/order_status.dart';
import 'package:picnicgarden/model/phase.dart';
import 'package:picnicgarden/model/recipe.dart';
import 'package:picnicgarden/model/table.dart';

abstract class OrderBuilder {
  void setTable(Table table);
  void setRecipe(Recipe recipe);
  void setPhase(Phase phase);
  void setOrderStatus(OrderStatus orderStatus);

  Order makeOrder();
}

class PGOrderBuilder implements OrderBuilder {
  Table _table;
  Recipe _recipe;
  Phase _phase;
  OrderStatus _orderStatus;

  @override
  Order makeOrder() {
    return Order(
      recipe: _recipe,
      table: _table,
      currentStatus: _orderStatus,
      phase: _phase,
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
