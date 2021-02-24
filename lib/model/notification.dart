import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'order.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification extends Equatable {
  final String id;

  final List<String> topicNames;
  final DateTime createdAt;
  final bool isUnread;

  final Order order;

  Notification({
    this.id,
    this.topicNames,
    this.createdAt,
    this.isUnread,
    this.order,
  });

  factory Notification.forOrder(Order order) {
    // ignore: omit_local_variable_types
    final Set<String> topicNames = order.recipe.attributes.fold(
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
      createdAt: DateTime.now(),
      isUnread: true,
      order: order,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  @override
  List<Object> get props => [id];
}
