import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'order_status.dart';
import 'recipe.dart';
import 'table.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  final String id;

  final Recipe recipe;
  final Table table;
  OrderStatus currentStatus;

  final DateTime created;
  DateTime delivered;

  Map<String, Duration> flow;

  Order({
    @required this.recipe,
    @required this.table,
    String id,
    DateTime created,
    Map<String, Duration> flow,
    this.currentStatus,
    this.delivered,
  })  : id = id ?? Uuid().v4(),
        created = created ?? DateTime.now(),
        flow = flow ?? {};

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

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
      ).difference(created).inSeconds,
    );
  }

  String get userFriendlyDescription => '${recipe.name} @ ${table.name}';

  static int sort(Order a, Order b) {
    var result =
        b.currentDuration.inSeconds.compareTo(a.currentDuration.inSeconds);
    if (result == 0) {
      result = a.recipe.name.compareTo(b.recipe.name);
    }
    return result;
  }
}
