import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../logic/api_response.dart';
import '../logic/pg_error.dart';

abstract class EntityProvider extends ChangeNotifier {
  ApiResponse get response;

  bool get isLoading;
}

class FIREntityProvider<T> extends ChangeNotifier implements EntityProvider {
  final CollectionReference collection;
  final T Function(Map<String, dynamic> json) fromJson;

  List<T> entities = [];

  @override
  ApiResponse response = ApiResponse.initial();

  FIREntityProvider(String collection, this.fromJson)
      : collection = FirebaseFirestore.instance.collection(collection);

  @override
  bool get isLoading => response.status == ApiStatus.loading;

  Future fetchEntities() async {
    response = ApiResponse.loading();
    notifyListeners();

    return (await checkConnectivity()).fold(
      () async {
        try {
          final snapshot = await collection.get();
          entities = snapshot.docs.map((doc) => fromJson(doc.data())).toList();
          response = ApiResponse.completed();
        } catch (e) {
          print('[ERROR] Failed fetching ${T.runtimeType}: $e');
          response = ApiResponse.error(PGError.backend('$e'));
        }
        notifyListeners();
      },
      (error) {
        response = ApiResponse.error(error);
        notifyListeners();
      },
    );
  }

  Future<PGError> putEntity(String id, Map<String, dynamic> entity) async {
    return (await checkConnectivity()).fold(
      () async {
        try {
          await collection.doc(id).set(entity);
          return null;
        } catch (e) {
          print('[ERROR] Failed putting ${T.runtimeType}: $e');
          return PGError.backend('$e');
        }
      },
      (error) => error,
    );
  }
}
