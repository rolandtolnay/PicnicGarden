// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    id: json['id'] as String,
    name: json['name'] as String,
    tabIndex: json['tabIndex'] as int,
    number: json['number'] as int,
    autoPhase: json['autoPhase'] as String?,
    attributes: (json['attributes'] as List<dynamic>?)
        ?.map((e) => Attribute.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tabIndex': instance.tabIndex,
      'number': instance.number,
      'autoPhase': instance.autoPhase,
      'attributes': instance.attributes.map((e) => e.toJson()).toList(),
    };
