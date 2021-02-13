import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'order_status.g.dart';

@JsonSerializable()
class OrderStatus {
  final String id;
  final String name;
  final String colorHex;
  final int flow;

  const OrderStatus(
      {@required this.id,
      @required this.name,
      @required this.colorHex,
      @required this.flow});

  factory OrderStatus.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusToJson(this);
}
