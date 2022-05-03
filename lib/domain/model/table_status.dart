import 'package:json_annotation/json_annotation.dart';

part 'table_status.g.dart';

@JsonSerializable()
class TableStatus {
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
}
