import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_entity.g.dart';

@JsonSerializable()
class TableEntity extends Equatable {
  final String id;
  final String name;
  final int number;

  const TableEntity(
      {required this.id, required this.name, required this.number});

  factory TableEntity.fromJson(Map<String, dynamic> json) =>
      _$TableEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TableEntityToJson(this);

  @override
  List<Object> get props => [id];
}
