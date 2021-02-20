import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picnicgarden/logic/api_response.dart';
import 'package:picnicgarden/logic/pg_error.dart';
import 'package:picnicgarden/model/notification.dart';
import 'package:picnicgarden/provider/entity_provider.dart';

abstract class NotificationProvider extends EntityProvider {
  UnmodifiableListView<Notification> get notifications;
}

class FIRNotificationProvider extends FIREntityProvider<Notification>
    implements NotificationProvider {
  StreamSubscription<QuerySnapshot> _snapshotListener;

  FIRNotificationProvider()
      : super('notifications', (json) => Notification.fromJson(json)) {
    response = ApiResponse.loading();
    _snapshotListener = collection
        .where('isUnread', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      final notificationList =
          snapshot.docs.map(_Notification.fromDoc).toList();
      entities = notificationList;
      response = ApiResponse.completed();
      notifyListeners();
    }, onError: (error) {
      response = ApiResponse.error(PGError.backend('$error'));
      notifyListeners();
    });
  }

  @override
  UnmodifiableListView<Notification> get notifications =>
      UnmodifiableListView(entities);

  @override
  void dispose() {
    _snapshotListener.cancel();
    super.dispose();
  }
}

extension _Notification on Notification {
  static Notification fromDoc(DocumentSnapshot doc) =>
      Notification.fromJson(doc.data());
}
