import 'dart:collection';

import 'package:picnicgarden/logic/pg_error.dart';

import '../logic/api_response.dart';
import '../model/notification.dart';
import 'entity_provider.dart';

abstract class NotificationProvider extends EntityProvider {
  UnmodifiableListView<Notification> get notifications;

  Future<PGError> postNotification(Notification notification);
}

class FIRNotificationProvider extends FIREntityProvider<Notification>
    implements NotificationProvider {
  FIRNotificationProvider()
      : super('notifications', (json) => Notification.fromJson(json)) {
    response = ApiResponse.loading();
    listenOnSnapshots(collection.where('isUnread', isEqualTo: false));
  }

  @override
  UnmodifiableListView<Notification> get notifications =>
      UnmodifiableListView(entities);

  @override
  Future<PGError> postNotification(Notification notification) {
    return putEntity(notification.id, notification.toJson());
  }
}
