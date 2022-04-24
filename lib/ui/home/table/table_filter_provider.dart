import 'package:flutter/material.dart';

abstract class TableFilterProvider extends ChangeNotifier {
  bool get showingEmptyTables;
  void setShowingEmptyTables(bool showing);
}

class TableFilterProviderImpl extends ChangeNotifier
    implements TableFilterProvider {
  TableFilterProviderImpl();

  bool _showingEmptyTables = true;

  @override
  bool get showingEmptyTables => _showingEmptyTables;

  @override
  void setShowingEmptyTables(bool showing) {
    _showingEmptyTables = showing;
    notifyListeners();
  }
}
