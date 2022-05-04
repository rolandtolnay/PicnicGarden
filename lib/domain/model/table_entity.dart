import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:picnicgarden/domain/model/table_status.dart';

part 'table_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class TableEntity extends Equatable {
  final String id;
  final String name;
  final int number;

  final TableStatus? status;

  const TableEntity({
    required this.id,
    required this.name,
    required this.number,
    required this.status,
  });

  factory TableEntity.fromJson(Map<String, dynamic> json) =>
      _$TableEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TableEntityToJson(this);

  TableEntity copyWith({required TableStatus? status}) => TableEntity(
        id: id,
        name: name,
        number: number,
        status: status,
      );

  @override
  List<Object> get props => [id];
}
