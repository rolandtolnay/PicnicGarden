// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    recipe: json['recipe'] == null
        ? null
        : Recipe.fromJson(json['recipe'] as Map<String, dynamic>),
    table: json['table'] == null
        ? null
        : Table.fromJson(json['table'] as Map<String, dynamic>),
    id: json['id'] as String,
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    flow: (json['flow'] as Map<String, dynamic>)?.map(
      (k, e) =>
          MapEntry(k, e == null ? null : Duration(microseconds: e as int)),
    ),
    currentStatus: json['currentStatus'] == null
        ? null
        : OrderStatus.fromJson(json['currentStatus'] as Map<String, dynamic>),
    delivered: json['delivered'] == null
        ? null
        : DateTime.parse(json['delivered'] as String),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'recipe': instance.recipe?.toJson(),
      'table': instance.table?.toJson(),
      'currentStatus': instance.currentStatus?.toJson(),
      'created': instance.created?.toIso8601String(),
      'delivered': instance.delivered?.toIso8601String(),
      'flow': instance.flow?.map((k, e) => MapEntry(k, e?.inMicroseconds)),
    };
