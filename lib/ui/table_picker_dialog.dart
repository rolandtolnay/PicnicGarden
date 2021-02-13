import 'dart:collection';

import 'package:flutter/material.dart' hide Table;

import '../model/table.dart';

class TablePickerDialog extends StatelessWidget {
  const TablePickerDialog(this.tables, {this.selectedTable, Key key})
      : super(key: key);

  final UnmodifiableListView<Table> tables;
  final Table selectedTable;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 2,
      title: Row(
        children: [
          Icon(Icons.tab),
          SizedBox(width: 8.0),
          Text('Select table'),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: tables
              .map((table) => _TableItem(
                    table.name,
                    isSelected: table == selectedTable,
                    onTapped: () => Navigator.of(context).pop(table),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _TableItem extends StatelessWidget {
  const _TableItem(
    this.tableName, {
    this.onTapped,
    this.isSelected = false,
    Key key,
  }) : super(key: key);

  final String tableName;
  final VoidCallback onTapped;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryVariant;
    final textColor =
        isSelected ? Theme.of(context).colorScheme.onPrimary : color;
    final textStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        );
    final text = Text(tableName, style: textStyle);

    return isSelected
        ? FlatButton(
            color: color,
            child: text,
            onPressed: () => onTapped?.call(),
          )
        : OutlineButton(
            borderSide: BorderSide(color: color, width: 2),
            child: text,
            onPressed: () => onTapped?.call());
  }
}
