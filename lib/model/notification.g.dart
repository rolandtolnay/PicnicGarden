// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    id: json['id'] as String,
    topicNames:
        (json['topicNames'] as List<dynamic>).map((e) => e as String).toList(),
    readBy: Map<String, bool>.from(json['readBy'] as Map),
    createdAt: DateTime.parse(json['createdAt'] as String),
    createdBy: json['createdBy'] as String,
    order: json['order'] == null
        ? null
        : Order.fromJson(json['order'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order?.toJson(),
      'topicNames': instance.topicNames,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'readBy': instance.readBy,
    };
