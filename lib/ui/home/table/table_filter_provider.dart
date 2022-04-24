import 'package:flutter/material.dart';

abstract class TableFilterProvider extends ChangeNotifier {
  bool get hidingEmptyTables;
  void setShowingEmptyTables(bool showing);

  bool get hasFiltersEnabled;
}

class TableFilterProviderImpl extends ChangeNotifier
    implements TableFilterProvider {
  TableFilterProviderImpl();

  bool _hidingEmptyTables = false;

  @override
  bool get hidingEmptyTables => _hidingEmptyTables;

  @override
  void setShowingEmptyTables(bool showing) {
    _hidingEmptyTables = showing;
    notifyListeners();
  }

  @override
  bool get hasFiltersEnabled => _hidingEmptyTables;
}
