import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'order_status.dart';
import '../phase.dart';
import '../recipe.dart';
import '../table_entity.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order extends Equatable {
  final String id;

  final Recipe recipe;
  final TableEntity table;
  final Phase phase;
  final String? customNote;

  final DateTime createdAt;
  final String createdBy;

  final Map<String, Duration> flow;
  final OrderStatus currentStatus;
  final String? delivered;

  Order({
    String? id,
    required this.recipe,
    required this.table,
    required this.phase,
    required this.createdBy,
    required this.currentStatus,
    this.customNote,
    DateTime? createdAt,
    Map<String, Duration>? flow,
    this.delivered,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        flow = flow ?? {};

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  String toString() => '${toJson()}';

  @override
  List<Object?> get props => [id];

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

  Order moveToNextFlow({required List<OrderStatus> orderStatusList}) {
    final currentFlow = currentStatus.flow;
    final nextFlow = currentFlow + 1;
    if (nextFlow >= orderStatusList.length) return this;

    var lastFlowEndDate = createdAt;
    final previousFlow = currentFlow - 1;
    if (previousFlow >= 0) {
      lastFlowEndDate = createdAt.add(
        flow.values.reduce(
          (result, element) {
            return Duration(seconds: result.inSeconds + element.inSeconds);
          },
        ),
      );
    }

    final now = DateTime.now();
    final updatedFlow = flow;
    updatedFlow[currentStatus.name] = Duration(
      seconds: now.difference(lastFlowEndDate).inSeconds,
    );

    String? updatedDelivered;
    if (nextFlow == orderStatusList.length - 1) {
      updatedDelivered = now.toIso8601String();
    }

    return Order(
      id: id,
      createdAt: createdAt,
      recipe: recipe,
      table: table,
      createdBy: createdBy,
      phase: phase,
      customNote: customNote,
      currentStatus: orderStatusList[nextFlow],
      delivered: updatedDelivered,
      flow: updatedFlow,
    );
  }

  static int sort(Order a, Order b) {
    var result =
        b.currentDuration.inSeconds.compareTo(a.currentDuration.inSeconds);
    if (result == 0) result = a.recipe.name.compareTo(b.recipe.name);
    return result;
  }
}
