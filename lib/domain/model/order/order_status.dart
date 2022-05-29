import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../attribute.dart';
import '../topic.dart';

part 'order_status.g.dart';

@JsonSerializable()
class OrderStatus extends Equatable {
  final String id;
  final String name;
  final String colorHex;
  final int flow;

  @JsonKey(defaultValue: {})
  final Map<TopicName, List<AttributeId>> notifyTopics;

  const OrderStatus({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.flow,
    required this.notifyTopics,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusToJson(this);

  @override
  List<Object?> get props => [id];
}
