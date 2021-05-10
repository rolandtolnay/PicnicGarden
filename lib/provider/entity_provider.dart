import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:either_option/either_option.dart';
import 'package:flutter/material.dart';
import 'package:picnicgarden/logic/pg_error.dart';

import '../logic/api_response.dart';

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

  FIREntityProvider(String? collection, this.fromJson) {
    if (collection != null) {
      this.collection = FirebaseFirestore.instance.collection(collection);
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
        } catch (e, stacktrace) {
          print('[ERROR] Failed fetching $T: $e');
          print(stacktrace);
          response = ApiResponse.error(PGError.backend(
            '$e',
            error: e as Exception,
          ));
        }
        notifyListeners();
      },
      (error) {
        response = ApiResponse.error(error);
        notifyListeners();
      },
    );
  }

  Future<PGError?> postEntity(String id, Map<String, dynamic> entity) async {
    return (await _checkConnectivity()).fold(
      () async {
        try {
          await collection.doc(id).set(entity);
          return null;
        } catch (e, stacktrace) {
          print('[ERROR] Failed putting $T: $e');
          print(stacktrace);
          return PGError.backend('$e', error: e as Exception);
        }
      },
      (error) => error,
    );
  }

  Future<PGError?> batchPutEntities(
    Iterable<String> ids,
    Map<String, dynamic> change,
  ) async {
    return (await _checkConnectivity()).fold(
      () async {
        try {
          final batch = FirebaseFirestore.instance.batch();
          ids.forEach((id) {
            batch.update(collection.doc(id), change);
          });
          await batch.commit();
          return null;
        } catch (e, stacktrace) {
          print('[ERROR] Failed putting $T: $e');
          print(stacktrace);
          return PGError.backend('$e', error: e as Exception);
        }
      },
      (error) => error,
    );
  }

  Future<PGError?> deleteEntity(String id) async {
    return (await _checkConnectivity()).fold(
      () async {
        try {
          await collection.doc(id).delete();
          return null;
        } catch (e, stacktrace) {
          print('[ERROR] Failed deleting $T: $e');
          print(stacktrace);
          return PGError.backend('$e', error: e as Exception);
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
    }, onError: (e, stacktrace) {
      print('[ERROR] Received snapshot error listening on $T: $e');
      print(stacktrace);
      response = ApiResponse.error(PGError.backend(
        '$e',
        error: e as Exception,
      ));
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
    snapshot.docs.forEach((doc) {
      if (doc.exists) {
        entities.add(fromJson(doc.data()));
      } else {
        print('[WARNING] Document $doc contains no data parsing $T.');
      }
    });
    return entities;
  }
}

Future<Option<PGError>> _checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return Option.cond(
    connectivityResult == ConnectivityResult.none,
    PGError.noInternet(),
  );
}
