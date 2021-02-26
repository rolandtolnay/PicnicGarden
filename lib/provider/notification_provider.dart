import 'dart:collection';

import 'package:meta/meta.dart';

import '../logic/api_response.dart';
import '../logic/pg_error.dart';
import '../model/notification.dart';
import '../model/table.dart';
import 'auth_provider.dart';
import 'entity_provider.dart';

abstract class NotificationProvider extends EntityProvider {
  UnmodifiableListView<Notification> get notifications;

  UnmodifiableListView<Notification> notificationsExcludingTable(Table table);
  UnmodifiableListView<Notification> notificationsForTable(Table table);

  Future<PGError> postNotification(Notification notification);
  Future<PGError> markAsReadNotifications(Table table);
}

class FIRNotificationProvider extends FIREntityProvider<Notification>
    implements NotificationProvider {
  FIRNotificationProvider({@required AuthProvider authProvider})
      : super('notifications', (json) => Notification.fromJson(json)) {
    response = ApiResponse.loading();
    if (authProvider.userId != null) {
      listenOnSnapshots(collection
          .where('createdBy', isNotEqualTo: authProvider.userId)
          .where('isUnread', isEqualTo: true));
    } else {
      print('[ERROR] NotificationProvider init with no authenticated user');
    }
  }

  @override
  UnmodifiableListView<Notification> get notifications =>
      UnmodifiableListView(entities);

  @override
  Future<PGError> postNotification(Notification notification) {
    return postEntity(notification.id, notification.toJson());
  }

  @override
  UnmodifiableListView<Notification> notificationsExcludingTable(Table table) {
    return UnmodifiableListView<Notification>(
      notifications.where((n) => n.order.table != table).toList(),
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
