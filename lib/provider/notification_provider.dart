import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:picnicgarden/model/order.dart';

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

  Future<PGError> postNotificationForOrder(Order order);
  Future<PGError> markAsReadNotifications(Table table);
}

class FIRNotificationProvider extends FIREntityProvider<Notification>
    implements NotificationProvider {
  final AuthProvider _authProvider;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FIRNotificationProvider({@required AuthProvider authProvider})
      : _authProvider = authProvider,
        super('notifications', (json) => Notification.fromJson(json)) {
    //
    response = ApiResponse.loading();
    if (authProvider.userId != null) {
      listenOnSnapshots(
        collection.where('createdBy', isNotEqualTo: authProvider.userId),
      );
    } else {
      print('[ERROR] NotificationProvider init with no authenticated user');
    }

    _initLocalNotifications();
    FirebaseMessaging.onMessage.listen((message) {
      print('Message data: ${message.data}');

      if (message.notification != null &&
          message.data['createdBy'] != _authProvider.userId) {
        _localNotificationsPlugin.show(
          0,
          message.notification.title,
          null,
          // TODO: Only show alert if for other table
          // TODO: Do not show if order status changed by me
          NotificationDetails(
              iOS: IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          )),
        );
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
  Future<PGError> postNotificationForOrder(Order order) {
    final notification = Notification.forOrder(
      order,
      createdBy: _authProvider.userId,
    );
    return postEntity(notification.id, notification.toJson());
  }

  @override
  UnmodifiableListView<Notification> notificationsExcludingTable(Table table) {
    return UnmodifiableListView<Notification>(
      entities
          .where((n) =>
              n.order.table != table && n.readBy[_authProvider.userId] == null)
          .toList(),
    );
  }

  @override
  UnmodifiableListView<Notification> notificationsForTable(Table table) {
    return UnmodifiableListView<Notification>(
      entities
          .where((n) =>
              n.order.table == table && n.readBy[_authProvider.userId] == null)
          .toList(),
    );
  }

  @override
  Future<PGError> markAsReadNotifications(Table table) {
    final notifications = notificationsForTable(table);
    return batchPutEntities(
      notifications.map((n) => n.id),
      {'readBy.${_authProvider.userId}': true},
    );
  }

  Future _initLocalNotifications() async {
    final initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          print('Received local notification');
        });
    final initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );
    await _localNotificationsPlugin.initialize(initializationSettings);
    print('Successfully initialized local notifications.');
  }
}
