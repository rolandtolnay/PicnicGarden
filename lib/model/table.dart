import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table.g.dart';

@JsonSerializable()
class Table extends Equatable {
  final String id;
  final String name;
  final int number;

  const Table({required this.id, required this.name, required this.number});

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);

  Map<String, dynamic> toJson() => _$TableToJson(this);

  @override
  List<Object> get props => [id];
}
