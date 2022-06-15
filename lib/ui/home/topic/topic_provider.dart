import 'dart:async';
import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../common/api_response.dart';
import '../../../domain/service_error.dart';
import '../../../domain/model/topic.dart';
import '../../auth_provider.dart';
import '../../entity_provider.dart';
import '../../restaurant/restaurant_provider.dart';

abstract class TopicProvider extends EntityProvider {
  UnmodifiableListView<Topic> get topics;
  Future<void> fetchTopics();

  bool isSubscribedToTopic(Topic topic);

  // ignore: avoid_positional_boolean_parameters
  Future<void> setSubscribedToTopic(bool isSubscribed, {required Topic topic});
}

@LazySingleton(as: TopicProvider)
class FIRTopicProvider extends FIREntityProvider<Topic>
    implements TopicProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final AuthProvider _authProvider;

  FIRTopicProvider({
    required AuthProvider authProvider,
    required RestaurantProvider restaurantProvider,
  })  : _authProvider = authProvider,
        super(
          'topics',
          Topic.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        ) {
    fetchTopics().then(_ensureSubscribedToTopics);
  }

  @override
  UnmodifiableListView<Topic> get topics => UnmodifiableListView(entities);

  @override
  Future<void> fetchTopics() => fetchEntities();

  @override
  bool isSubscribedToTopic(Topic topic) =>
      topic.subscribedUserIds.contains(_authProvider.userId);

  @override
  Future<void> setSubscribedToTopic(bool isSubscribed,
      {required Topic topic}) async {
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
          ? Topic.subscribingTo(topic, userId: userId!)
          : Topic.unsubscribingFrom(topic, userId: userId!);
      final error = await postEntity(topic.id, updatedTopic.toJson());
      if (error == null) {
        response = ApiResponse.completed();
      } else {
        response = ApiResponse.error(error);
      }
    } catch (e) {
      response = ApiResponse.error(ServiceError.unknown('$e', error: e));
    }
    notifyListeners();
  }

  Future<void> _ensureSubscribedToTopics(_) async {
    if (topics.isNotEmpty) {
      for (final topic in topics) {
        if (isSubscribedToTopic(topic)) {
          await _messaging.subscribeToTopic(topic.name.toLowerCase());
        }
      }
    }
  }
}
