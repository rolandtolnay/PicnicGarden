import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attribute.g.dart';

@JsonSerializable()
class Attribute extends Equatable {
  final String id;
  final String name;

  const Attribute({required this.id, required this.name});

  @override
  List<Object> get props => [id];

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);
}
