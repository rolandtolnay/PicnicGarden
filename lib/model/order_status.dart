import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'order_status.g.dart';

@JsonSerializable()
class OrderStatus {
  final String id;
  final String name;
  final String colorHex;
  final int flow;

  /// { topic_name: [attribute_id] }
  @JsonKey(defaultValue: {})
  final Map<String, List<String>> notifyTopics;

  const OrderStatus(
      {@required this.id,
      @required this.name,
      @required this.colorHex,
      @required this.flow,
      this.notifyTopics});

  factory OrderStatus.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusToJson(this);
}
