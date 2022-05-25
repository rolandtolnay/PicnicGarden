import 'package:picnicgarden/domain/model/table_entity.dart';

import 'table_status.dart';

import 'package:json_annotation/json_annotation.dart';

part 'table_status_change.g.dart';

@JsonSerializable()
class TableStatusChange {
  final TableStatus status;
  final TableEntity table;

  TableStatusChange(this.status, this.table);

  factory TableStatusChange.fromJson(Map<String, dynamic> json) =>
      _$TableStatusChangeFromJson(json);

  Map<String, dynamic> toJson() => _$TableStatusChangeToJson(this);
}
