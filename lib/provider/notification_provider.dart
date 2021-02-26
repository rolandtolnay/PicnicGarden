import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../logic/api_response.dart';
import '../logic/pg_error.dart';
import '../model/notification.dart';
import '../model/table.dart';
import 'entity_provider.dart';

abstract class NotificationProvider extends EntityProvider {
  UnmodifiableListView<Notification> get notifications;

// TODO: This should take table parameter
  UnmodifiableListView<Notification> notificationsExcludingTable(
    String tableName,
  );
  UnmodifiableListView<Notification> notificationsForTable(Table table);

  Future<PGError> postNotification(Notification notification);
  Future<PGError> markAsReadNotifications(Table table);
}

class FIRNotificationProvider extends FIREntityProvider<Notification>
    implements NotificationProvider {
  FIRNotificationProvider()
      : super('notifications', (json) => Notification.fromJson(json)) {
    response = ApiResponse.loading();
    listenOnSnapshots(collection.where('isUnread', isEqualTo: true));
  }

  @override
  UnmodifiableListView<Notification> get notifications =>
      UnmodifiableListView(entities);

  @override
  Future<PGError> postNotification(Notification notification) {
    return postEntity(notification.id, notification.toJson());
  }

  @override
  UnmodifiableListView<Notification> notificationsExcludingTable(
    String tableName,
  ) {
    return UnmodifiableListView<Notification>(
      notifications.where((n) => n.order.table.name != tableName).toList(),
    );
  }

  @override
  UnmodifiableListView<Notification> notificationsForTable(Table table) {
    return UnmodifiableListView<Notification>(
      notifications.where((n) => n.order.table == table).toList(),
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
