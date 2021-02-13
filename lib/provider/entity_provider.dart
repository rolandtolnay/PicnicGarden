import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../logic/api_response.dart';
import '../logic/pg_error.dart';

abstract class EntityProvider extends ChangeNotifier {
  ApiResponse get response;

  bool get isLoading;
}

class FIREntityProvider<T> extends ChangeNotifier implements EntityProvider {
  final CollectionReference _collection;
  final T Function(Map<String, dynamic> json) fromJson;

  List<T> _entities = [];

  ApiResponse _response = ApiResponse.initial();

  FIREntityProvider(String collection, this.fromJson)
      : _collection = FirebaseFirestore.instance.collection(collection);

  @override
  ApiResponse get response => _response;
  @override
  bool get isLoading => response.status == ApiStatus.loading;

  UnmodifiableListView<T> get entities => UnmodifiableListView(_entities);

  Future fetchEntities() async {
    _response = ApiResponse.loading();
    notifyListeners();

    try {
      final snapshot = await _collection.get();
      _entities = snapshot.docs.map((doc) => fromJson(doc.data())).toList();
      _response = ApiResponse.completed();
    } catch (e) {
      print('[ERROR] Failed fetching activities: $e');
      _response = ApiResponse.error(PGError.backend('$e'));
    }
    notifyListeners();
  }
}
