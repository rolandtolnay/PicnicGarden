// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatus _$OrderStatusFromJson(Map<String, dynamic> json) {
  return OrderStatus(
    id: json['id'] as String,
    name: json['name'] as String,
    colorHex: json['colorHex'] as String,
    flow: json['flow'] as int,
    notifyTopics: (json['notifyTopics'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
        ) ??
        {},
  );
}

Map<String, dynamic> _$OrderStatusToJson(OrderStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colorHex': instance.colorHex,
      'flow': instance.flow,
      'notifyTopics': instance.notifyTopics,
    };
