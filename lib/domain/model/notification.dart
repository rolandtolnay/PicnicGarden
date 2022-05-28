import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../compact_map.dart';
import 'order/order.dart';
import 'table_entity.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification extends Equatable {
  final String id;
  final Order? order;
  final TableEntity? table;

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
    this.table,
  });

  factory Notification.forOrder(Order order, {required String createdBy}) {
    final topicNames = order.recipe.attributes.fold<Set<String>>(
      {},
      (topicNameList, attribute) {
        order.currentStatus.notifyTopics.forEach((topicName, attrIdList) {
          if (attrIdList.contains(attribute.id)) {
            topicNameList.add(topicName.toLowerCase());
          }
        });
        return topicNameList;
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
    TableEntity table, {
    required String createdBy,
  }) {
    return Notification(
      id: Uuid().v4(),
      topicNames: table.status?.notifyTopics
              .compactMap((e) => e.isNotEmpty ? e.toLowerCase() : null)
              .toList() ??
          [],
      readBy: const {},
      createdAt: DateTime.now(),
      createdBy: createdBy,
      table: table,
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
