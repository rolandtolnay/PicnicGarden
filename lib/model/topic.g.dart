// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return Topic(
    id: json['id'] as String,
    name: json['name'] as String,
    subscribedUserIds:
        (json['subscribedUserIds'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subscribedUserIds': instance.subscribedUserIds,
    };
