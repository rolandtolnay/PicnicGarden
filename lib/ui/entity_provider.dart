import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:either_option/either_option.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../domain/service_error.dart';
import '../domain/model/restaurant.dart';

import 'common/api_response.dart';

abstract class EntityProvider extends ChangeNotifier {
  ApiResponse get response;

  bool get isLoading;
  bool get isCompleted;
  bool get hasError;
}

class FIREntityProvider<T> extends ChangeNotifier implements EntityProvider {
  late CollectionReference<Map<String, dynamic>> collection;
  final T Function(Map<String, dynamic> json) fromJson;

  List<T> entities = [];
  StreamSubscription<QuerySnapshot>? snapshotListener;

  @override
  ApiResponse response = ApiResponse.initial();

  FIREntityProvider(
    String? collection,
    this.fromJson, {
    Restaurant? restaurant,
  }) {
    if (collection != null) {
      if (restaurant != null) {
        this.collection = FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurant.id)
            .collection(collection);
      } else {
        this.collection = FirebaseFirestore.instance.collection(collection);
      }
    }
  }

  @override
  bool get isLoading => response.status == ApiStatus.loading;

  @override
  bool get isCompleted => response.status == ApiStatus.completed;

  @override
  bool get hasError => response.error != null;

  Future fetchEntities({Query<Map<String, dynamic>>? query}) async {
    response = ApiResponse.loading();
    notifyListeners();

    return (await _checkConnectivity()).fold(
      () async {
        try {
          final fetchQuery = query ?? collection;
          final snapshot = await fetchQuery.get();

          entities = _entitiesFromSnapshot(snapshot);
          print('Successfully fetched ${entities.length} $T entities.');
          response = ApiResponse.completed();
        } catch (e, st) {
          print('[ERROR] Failed fetching $T: $e');
          print(st);
          await FirebaseCrashlytics.instance
              .recordError(e, st, reason: 'Failed fetching $T');
          response = ApiResponse.error(ServiceError.backend('$e', error: e));
        }
        notifyListeners();
      },
      (error) async {
        await FirebaseCrashlytics.instance
            .recordError(error, null, reason: 'Failed fetching $T');
        response = ApiResponse.error(error);
        notifyListeners();
      },
    );
  }

  Future<ServiceError?> postEntity(
      String id, Map<String, dynamic> entity) async {
    return (await _checkConnectivity()).fold(
      () async {
        try {
          await collection.doc(id).set(entity);
          return null;
        } catch (e, st) {
          print('[ERROR] Failed putting $T: $e');
          print(st);
          await FirebaseCrashlytics.instance
              .recordError(e, st, reason: 'Failed putting $T');
          return ServiceError.backend('$e', error: e);
        }
      },
      (error) => error,
    );
  }

  Future<ServiceError?> batchPutEntities(
    Iterable<String> ids,
    Map<String, dynamic> change,
  ) async {
    return (await _checkConnectivity()).fold(
      () async {
        try {
          final batch = FirebaseFirestore.instance.batch();
          for (var id in ids) {
            batch.update(collection.doc(id), change);
          }
          await batch.commit();
          return null;
        } catch (e, st) {
          print('[ERROR] Failed putting $T: $e');
          print(st);
          await FirebaseCrashlytics.instance
              .recordError(e, st, reason: 'Failed putting $T');
          return ServiceError.backend('$e', error: e);
        }
      },
      (error) => error,
    );
  }

  Future<ServiceError?> deleteEntity(String id) async {
    return (await _checkConnectivity()).fold(
      () async {
        try {
          await collection.doc(id).delete();
          return null;
        } catch (e, st) {
          print('[ERROR] Failed deleting $T: $e');
          print(st);
          await FirebaseCrashlytics.instance
              .recordError(e, st, reason: 'Failed deleting $T');
          return ServiceError.backend('$e', error: e);
        }
      },
      (error) => error,
    );
  }

  void listenOnSnapshots({Query<Map<String, dynamic>>? query}) {
    snapshotListener?.cancel();
    final listenQuery = query ?? collection;
    snapshotListener = listenQuery.snapshots().listen((snapshot) {
      entities = _entitiesFromSnapshot(snapshot);
      print('Received $T snapshot with ${entities.length} entities.');
      response = ApiResponse.completed();
      notifyListeners();
    }, onError: (e, st) async {
      print('[ERROR] Received snapshot error listening on $T: $e');
      print(st);
      await FirebaseCrashlytics.instance.recordError(e, st,
          reason: 'Received snapshot error listening on $T');
      response = ApiResponse.error(ServiceError.backend('$e', error: e));
      notifyListeners();
    });
  }

  @override
  void dispose() {
    snapshotListener?.cancel();
    super.dispose();
  }

  List<T> _entitiesFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final entities = <T>[];
    for (var doc in snapshot.docs) {
      if (doc.exists) {
        entities.add(fromJson(doc.data()));
      } else {
        print('[WARNING] Document $doc contains no data parsing $T.');
      }
    }
    return entities;
  }
}

Future<Option<ServiceError>> _checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return Option.cond(
    connectivityResult == ConnectivityResult.none,
    ServiceError.noInternet(),
  );
}
