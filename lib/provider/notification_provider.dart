import 'dart:collection';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:picnicgarden/provider/restaurant_provider.dart';

import '../logic/api_response.dart';
import '../logic/pg_error.dart';
import '../model/notification.dart';
import '../model/order.dart';
import '../model/table.dart';
import 'auth_provider.dart';
import 'entity_provider.dart';
import 'table_provider.dart';
import 'topic_provider.dart';

abstract class NotificationProvider extends EntityProvider {
  Future requestPermissions();

  UnmodifiableListView<Notification> notificationsExcludingTable(Table table);
  UnmodifiableListView<Notification> notificationsForTable(Table table);

  Future<PGError?> postNotificationForOrder(Order order);
}

class FIRNotificationProvider extends FIREntityProvider<Notification>
    implements NotificationProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AuthProvider _authProvider;
  final TopicProvider _topicProvider;
  final TableProvider _tableProvider;

  FIRNotificationProvider({
    required AuthProvider authProvider,
    required TopicProvider topicProvider,
    required TableProvider tableProvider,
    required RestaurantProvider restaurantProvider,
  })  : _authProvider = authProvider,
        _topicProvider = topicProvider,
        _tableProvider = tableProvider,
        super(
          'notifications',
          Notification.fromJson,
          restaurant: restaurantProvider.selectedRestaurant,
        ) {
    //
    response = ApiResponse.loading();
    if (authProvider.userId != null) {
      listenOnSnapshots(
        query: collection.where('createdBy', isNotEqualTo: authProvider.userId),
      );
    } else {
      print('[ERROR] NotificationProvider init with no authenticated user');
    }

    if (!kIsWeb) {
      _initLocalNotifications();
      _listenOnPushNotifications();
    }
    _listenOnTableSelected();
    _listenOnSubscribedTopic();
  }

  @override
  Future requestPermissions() async {
    if (kIsWeb) return;

    try {
      final settings = await _messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Push Notifications authorized.');
      } else {
        print('Push Notifications not authorized');
      }
    } catch (e) {
      print('[ERROR] Failed setting up notifications: $e');
    }
    return Future.value();
  }

  @override
  UnmodifiableListView<Notification> notificationsExcludingTable(Table table) {
    return UnmodifiableListView<Notification>(
      entities
          .where((n) =>
              n.order!.table != table &&
              n.readBy[_authProvider.userId!] == null &&
              n.topicNames.any(_isSubscribedToTopic))
          .toList(),
    );
  }

  @override
  UnmodifiableListView<Notification> notificationsForTable(Table table) {
    return UnmodifiableListView<Notification>(
      entities
          .where((n) =>
              n.order!.table == table &&
              n.readBy[_authProvider.userId!] == null &&
              n.topicNames.any(_isSubscribedToTopic))
          .toList(),
    );
  }

  @override
  Future<PGError?> postNotificationForOrder(Order order) {
    final notification = Notification.forOrder(
      order,
      createdBy: _authProvider.userId!,
    );
    return postEntity(notification.id, notification.toJson());
  }

  bool _isSubscribedToTopic(String topicName) {
    final topic = _topicProvider.topics.firstWhereOrNull(
        (t) => t.name.toLowerCase() == topicName.toLowerCase());
    if (topic == null) return false;
    return _topicProvider.isSubscribedToTopic(topic);
  }

  Future<PGError?> _markAsReadNotifications(Table table) {
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
            (int id, String? title, String? body, String? payload) async {
          print('Received local notification');
        });
    final initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );
    await _localNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (tableId) async {
      if (tableId != null) {
        _selectTableId(tableId);
      }
    });
    print('Successfully initialized local notifications.');
  }

  Future<void> _listenOnPushNotifications() async {
    FirebaseMessaging.onMessage.listen((message) {
      print('Message data: ${message.data}');

      if (message.notification != null &&
          message.data['createdBy'] != _authProvider.userId) {
        final tableId = message.data['tableId'] as String;
        var presentAlert = true;
        if (tableId == _tableProvider.selectedTable?.id) {
          presentAlert = false;
          _markAsReadNotifications(_tableProvider.selectedTable!);
        }

        _localNotificationsPlugin.show(
          0,
          message.notification!.title,
          null,
          NotificationDetails(
              iOS: IOSNotificationDetails(
            presentAlert: presentAlert,
            presentBadge: true,
            presentSound: true,
            sound: message.data['sound'],
          )),
          payload: tableId,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final tableId = message.data['tableId'];
      if (tableId != null) {
        _selectTableId(tableId);
      }
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final tableId = initialMessage.data['tableId'];
      if (tableId != null) {
        _selectTableId(tableId);
      }
    }
  }

  void _listenOnTableSelected() {
    _tableProvider.addListener(() async {
      if (_tableProvider.selectedTable != null) {
        final error =
            await _markAsReadNotifications(_tableProvider.selectedTable!);
        if (error != null) {
          print('[ERROR] Failed marking notifications as read: $error');
        }
      }
    });
  }

  void _listenOnSubscribedTopic() {
    _topicProvider.addListener(() {
      if (!_topicProvider.isLoading) {
        notifyListeners();
      }
    });
  }

  void _selectTableId(String tableId) {
    final table =
        _tableProvider.tables.firstWhereOrNull((t) => t.id == tableId);
    if (table != null) {
      _tableProvider.selectTable(table);
    }
  }
}
