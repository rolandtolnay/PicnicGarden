import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic extends Equatable {
  final String id;
  final String name;

  @JsonKey(defaultValue: <String>[])
  final List<String> subscribedUserIds;

  Topic({this.id, this.name, this.subscribedUserIds});

  factory Topic.subscribingTo(Topic topic, {@required String byUserId}) {
    final subscribedUserIds = topic.subscribedUserIds;
    subscribedUserIds.add(byUserId);
    return Topic(
      id: topic.id,
      name: topic.name,
      subscribedUserIds: subscribedUserIds,
    );
  }

  factory Topic.unsubscribingFrom(Topic topic, {@required String byUserId}) {
    final subscribedUserIds = topic.subscribedUserIds;
    subscribedUserIds.remove(byUserId);
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
