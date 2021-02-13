// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) {
  return Table(
    id: json['id'] as String,
    name: json['name'] as String,
    number: json['number'] as int,
  );
}

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
    };
