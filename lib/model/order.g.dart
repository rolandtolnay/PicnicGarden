// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    recipe: Recipe.fromJson(json['recipe'] as Map<String, dynamic>),
    table: Table.fromJson(json['table'] as Map<String, dynamic>),
    createdBy: json['createdBy'] as String,
    phase: Phase.fromJson(json['phase'] as Map<String, dynamic>),
    id: json['id'] as String?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    flow: (json['flow'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, Duration(microseconds: e as int)),
    ),
    currentStatus:
        OrderStatus.fromJson(json['currentStatus'] as Map<String, dynamic>),
    delivered: json['delivered'] == null
        ? null
        : DateTime.parse(json['delivered'] as String),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'recipe': instance.recipe.toJson(),
      'table': instance.table.toJson(),
      'phase': instance.phase.toJson(),
      'currentStatus': instance.currentStatus.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'delivered': instance.delivered?.toIso8601String(),
      'flow': instance.flow.map((k, e) => MapEntry(k, e.inMicroseconds)),
    };
