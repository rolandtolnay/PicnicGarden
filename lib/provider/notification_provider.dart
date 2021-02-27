import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

import '../logic/api_response.dart';
import '../logic/pg_error.dart';
import '../model/notification.dart';
import '../model/table.dart';
import 'auth_provider.dart';
import 'entity_provider.dart';

abstract class NotificationProvider extends EntityProvider {
  Future requestPermissions();

  UnmodifiableListView<Notification> notificationsExcludingTable(Table table);
  UnmodifiableListView<Notification> notificationsForTable(Table table);

  Future<PGError> postNotification(Notification notification);
  Future<PGError> markAsReadNotifications(Table table);
}

class FIRNotificationProvider extends FIREntityProvider<Notification>
    implements NotificationProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FIRNotificationProvider({@required AuthProvider authProvider})
      : super('notifications', (json) => Notification.fromJson(json)) {
    //
    response = ApiResponse.loading();
    if (authProvider.userId != null) {
      listenOnSnapshots(collection
          .where('createdBy', isNotEqualTo: authProvider.userId)
          .where('isUnread', isEqualTo: true));
    } else {
      print('[ERROR] NotificationProvider init with no authenticated user');
    }

    FirebaseMessaging.onMessage.listen((message) {
      // called in Foreground
      // TODO: Present local notification if needed
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Future requestPermissions() async {
    try {
      final settings = await _messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Push Notifications authorized.');
      } else {
        print('Push Notifications not authorized');
      }
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: true,
      );
    } catch (e) {
      print('[ERROR] Failed setting up notifications: $e');
    }
    return Future.value();
  }

  @override
  Future<PGError> postNotification(Notification notification) {
    return postEntity(notification.id, notification.toJson());
  }

  @override
  UnmodifiableListView<Notification> notificationsExcludingTable(Table table) {
    return UnmodifiableListView<Notification>(
      entities.where((n) => n.order.table != table).toList(),
    );
  }

  @override
  UnmodifiableListView<Notification> notificationsForTable(Table table) {
    return UnmodifiableListView<Notification>(
      entities.where((n) => n.order.table == table).toList(),
    );
  }

  @override
  Future<PGError> markAsReadNotifications(Table table) {
    final notifications = notificationsForTable(table);
    return batchPutEntities(
      notifications.map((n) => n.id),
      {'isUnread': false},
    );
  }
}
