import 'dart:collection';

import 'package:picnicgarden/provider/auth_provider.dart';

import '../model/topic.dart';
import 'entity_provider.dart';

abstract class TopicProvider extends EntityProvider {
  UnmodifiableListView<Topic> get topics;
  Future fetchTopics();

  bool isSubscribedToTopic(Topic topic);
  Future subscribeToTopic(Topic topic);
}

class FIRTopicProvider extends FIREntityProvider<Topic>
    implements TopicProvider {
  final AuthProvider _authProvider;

  FIRTopicProvider({AuthProvider authProvider})
      : _authProvider = authProvider,
        super('topics', (json) => Topic.fromJson(json));

  @override
  UnmodifiableListView<Topic> get topics => UnmodifiableListView(entities);

  @override
  Future fetchTopics() {
    return fetchEntities();
  }

  @override
  bool isSubscribedToTopic(Topic topic) =>
      topic.subscribedUserIds.contains(_authProvider.userId);

  @override
  Future subscribeToTopic(Topic topic) {
    return putEntity(
      topic.id,
      Topic.subscribingTo(topic, byUserId: _authProvider.userId).toJson(),
    );
  }
}
