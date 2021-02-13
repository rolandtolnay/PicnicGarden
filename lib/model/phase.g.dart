// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Phase _$PhaseFromJson(Map<String, dynamic> json) {
  return Phase(
    id: json['id'] as String,
    name: json['name'] as String,
    number: json['number'] as int,
  );
}

Map<String, dynamic> _$PhaseToJson(Phase instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
    };
