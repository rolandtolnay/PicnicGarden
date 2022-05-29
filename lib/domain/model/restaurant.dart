import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  final String id;
  final String name;
  final String imageName;

  @JsonKey(defaultValue: defaultOrderGroupWarningMinutes)
  final int orderGroupWarningMinutes;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageName,
    required this.orderGroupWarningMinutes,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  Duration get orderGroupWarningInterval =>
      Duration(minutes: orderGroupWarningMinutes);

  static const defaultOrderGroupWarningMinutes = 7;
  static const defaultOrderGroupWarningInterval =
      Duration(minutes: defaultOrderGroupWarningMinutes);
}
