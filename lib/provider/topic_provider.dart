import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:picnicgarden/logic/api_response.dart';

import '../model/topic.dart';
import 'auth_provider.dart';
import 'entity_provider.dart';

abstract class TopicProvider extends EntityProvider {
  UnmodifiableListView<Topic> get topics;
  Future fetchTopics();

  bool isSubscribedToTopic(Topic topic);

  // ignore: avoid_positional_boolean_parameters
  Future setSubscribedToTopic(bool isSubscribed, {@required Topic topic});
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
  Future setSubscribedToTopic(bool isSubscribed, {Topic topic}) async {
    response = ApiResponse.loading();
    notifyListeners();

    final userId = _authProvider.userId;
    final updatedTopic = isSubscribed
        ? Topic.subscribingTo(topic, byUserId: userId)
        : Topic.unsubscribingFrom(topic, byUserId: userId);
    final error = await putEntity(topic.id, updatedTopic.toJson());
    if (error == null) {
      response = ApiResponse.completed();
      // TODO: Call FCM
    } else {
      response = ApiResponse.error(error);
    }
    notifyListeners();
  }
}
