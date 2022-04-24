import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'order_status.dart';
import 'phase.dart';
import 'recipe.dart';
import 'table_entity.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  final String id;

  final Recipe recipe;
  final TableEntity table;
  final Phase phase;
  OrderStatus currentStatus;

  final DateTime createdAt;
  final String createdBy;

  DateTime? delivered;

  Map<String, Duration> flow;

  Order({
    required this.recipe,
    required this.table,
    required this.createdBy,
    required this.phase,
    String? id,
    DateTime? createdAt,
    Map<String, Duration>? flow,
    required this.currentStatus,
    this.delivered,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        flow = flow ?? {};

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  String toString() => '${toJson()}';

  Duration get currentDuration {
    final now = DateTime.now();
    return Duration(
      // recreating date time to ignore milliseconds for sorting purposes
      seconds: DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
      ).difference(createdAt).inSeconds,
    );
  }

  String get userFriendlyDescription =>
      '${recipe.name} @ ${table.name} ${phase.name}';

  bool get shouldNotifyStatus {
    final attributeIds = recipe.attributes.map((a) => a.id);
    final notifyAttributeIds =
        currentStatus.notifyTopics.values.expand((e) => e);
    return attributeIds.any(notifyAttributeIds.contains);
  }

  static int sort(Order a, Order b) {
    var result =
        b.currentDuration.inSeconds.compareTo(a.currentDuration.inSeconds);
    if (result == 0) {
      result = a.recipe.name.compareTo(b.recipe.name);
    }
    return result;
  }
}
