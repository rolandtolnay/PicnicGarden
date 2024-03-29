import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

typedef TopicName = String;

@JsonSerializable()
class Topic extends Equatable {
  final String id;
  final TopicName name;

  @JsonKey(defaultValue: <String>[])
  final List<String> subscribedUserIds;

  const Topic({
    required this.id,
    required this.name,
    required this.subscribedUserIds,
  });

  factory Topic.subscribingTo(Topic topic, {required String userId}) {
    final subscribedUserIds = topic.subscribedUserIds;
    subscribedUserIds.add(userId);
    return Topic(
      id: topic.id,
      name: topic.name,
      subscribedUserIds: subscribedUserIds,
    );
  }

  factory Topic.unsubscribingFrom(Topic topic, {required String userId}) {
    final subscribedUserIds = topic.subscribedUserIds;
    subscribedUserIds.remove(userId);
    return Topic(
      id: topic.id,
      name: topic.name,
      subscribedUserIds: subscribedUserIds,
    );
  }

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

  @override
  List<Object> get props => [id];
}
