import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'attribute.dart';

part 'recipe.g.dart';

@JsonSerializable(explicitToJson: true)
class Recipe {
  final String id;
  final String name;

  List<Attribute> attributes;

  Recipe({@required this.id, @required this.name, List<Attribute> attributes})
      : attributes = attributes ?? [];

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
