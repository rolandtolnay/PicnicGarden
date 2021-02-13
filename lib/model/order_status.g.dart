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
  );
}

Map<String, dynamic> _$OrderStatusToJson(OrderStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colorHex': instance.colorHex,
      'flow': instance.flow,
    };
