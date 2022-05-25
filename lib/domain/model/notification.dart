import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'order.dart';
import 'table_status_change.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification extends Equatable {
  final String id;
  final Order? order;
  final TableStatusChange? tableStatusChange;

  final List<String> topicNames;
  final DateTime createdAt;
  final String createdBy;
  final Map<String, bool> readBy;

  const Notification({
    required this.id,
    required this.topicNames,
    required this.readBy,
    required this.createdAt,
    required this.createdBy,
    this.order,
    this.tableStatusChange,
  });

  factory Notification.forOrder(Order order, {required String createdBy}) {
    final topicNames = order.recipe.attributes.fold<Set<String>>(
      <String>{},
      (topicNames, attribute) {
        order.currentStatus.notifyTopics.forEach((key, value) {
          if (value.contains(attribute.id)) {
            topicNames.add(key.toLowerCase());
          }
        });
        return topicNames;
      },
    );

    return Notification(
      id: Uuid().v4(),
      topicNames: List.from(topicNames),
      readBy: const {},
      createdAt: DateTime.now(),
      createdBy: createdBy,
      order: order,
    );
  }

  factory Notification.forTableStatusChange(
    TableStatusChange change, {
    required String createdBy,
  }) {
    return Notification(
      id: Uuid().v4(),
      topicNames: change.status.notifyTopics,
      readBy: const {},
      createdAt: DateTime.now(),
      createdBy: createdBy,
      tableStatusChange: change,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  @override
  List<Object> get props => [id];

  @override
  String toString() => '-Notification $topicNames readBy $readBy-';
}
