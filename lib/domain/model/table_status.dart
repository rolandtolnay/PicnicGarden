import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../extensions.dart';

part 'table_status.g.dart';

@JsonSerializable()
class TableStatus extends Equatable {
  final String id;
  final String name;
  final String colorHex;
  final int flow;

  @JsonKey(defaultValue: [])
  final List<String> notifyTopics;

  const TableStatus(
      {required this.id,
      required this.name,
      required this.colorHex,
      required this.flow,
      required this.notifyTopics});

  factory TableStatus.fromJson(Map<String, dynamic> json) =>
      _$TableStatusFromJson(json);

  Map<String, dynamic> toJson() => _$TableStatusToJson(this);

  @override
  List<Object?> get props => [id];

  Color? get backgroundColor =>
      colorHex.isNotEmpty ? HexColor.fromHex(colorHex) : null;
}
