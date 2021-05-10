import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../logic/api_response.dart';
import '../logic/pg_error.dart';
import '../model/topic.dart';
import 'auth_provider.dart';
import 'entity_provider.dart';

abstract class TopicProvider extends EntityProvider {
  UnmodifiableListView<Topic> get topics;
  Future fetchTopics();

  bool isSubscribedToTopic(Topic topic);

  // ignore: avoid_positional_boolean_parameters
  Future setSubscribedToTopic(bool isSubscribed, {required Topic topic});
}

class FIRTopicProvider extends FIREntityProvider<Topic>
    implements TopicProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final AuthProvider _authProvider;

  FIRTopicProvider({required AuthProvider authProvider})
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
  Future setSubscribedToTopic(bool isSubscribed, {required Topic topic}) async {
    response = ApiResponse.loading();
    notifyListeners();

    try {
      if (isSubscribed) {
        await _messaging.subscribeToTopic(topic.name.toLowerCase());
      } else {
        await _messaging.unsubscribeFromTopic(topic.name.toLowerCase());
      }
      final userId = _authProvider.userId;
      final updatedTopic = isSubscribed
          ? Topic.subscribingTo(topic, byUserId: userId!)
          : Topic.unsubscribingFrom(topic, byUserId: userId!);
      final error = await postEntity(topic.id, updatedTopic.toJson());
      if (error == null) {
        response = ApiResponse.completed();
      } else {
        response = ApiResponse.error(error);
      }
    } catch (e) {
      response =
          ApiResponse.error(PGError.unknown('$e', error: e as Exception));
    }
    notifyListeners();
  }
}
