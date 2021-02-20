// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    id: json['id'] as String,
    topicNames: (json['topicNames'] as List)?.map((e) => e as String)?.toList(),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    isUnread: json['isUnread'] as bool,
    order: json['order'] == null
        ? null
        : Order.fromJson(json['order'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicNames': instance.topicNames,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isUnread': instance.isUnread,
      'order': instance.order?.toJson(),
    };
