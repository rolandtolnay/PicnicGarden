import '../../../domain/model/order.dart';
import '../../../domain/model/order_status.dart';
import '../../../domain/model/phase.dart';
import '../../../domain/model/recipe.dart';
import '../../../domain/model/table_entity.dart';
import '../../auth_provider.dart';

abstract class OrderBuilder {
  void setTable(TableEntity table);
  void setRecipe(Recipe recipe);
  void setPhase(Phase phase);
  void setOrderStatus(OrderStatus orderStatus);
  void setCustomNote(String note);

  Order? makeOrder();
}

class OrderBuilderImpl implements OrderBuilder {
  final AuthProvider _authProvider;
  TableEntity? _table;
  Recipe? _recipe;
  Phase? _phase;
  OrderStatus? _orderStatus;
  String? _customNote;

  OrderBuilderImpl({required AuthProvider authProvider})
      : _authProvider = authProvider;

  @override
  Order? makeOrder() {
    if (_table == null ||
        _recipe == null ||
        _phase == null ||
        _orderStatus == null) return null;

    final note = (_customNote ?? '').isEmpty ? null : _customNote;
    return Order(
      recipe: _recipe!,
      table: _table!,
      currentStatus: _orderStatus!,
      phase: _phase!,
      createdBy: _authProvider.userId!,
      customNote: note,
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
  void setTable(TableEntity table) {
    _table = table;
  }

  @override
  void setCustomNote(String note) {
    _customNote = note;
  }
}
