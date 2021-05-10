import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthProvider extends ChangeNotifier {
  bool get isAuthenticated;

  String? get userId;

  Future<void> signIn();
}

class FIRAuthProvider extends ChangeNotifier implements AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get userId => _userId;

  bool _isAuthenticated = false;
  String? _userId;

  FIRAuthProvider() {
    _auth.authStateChanges().listen((user) {
      _isAuthenticated = user != null;
      _userId = user?.uid;
      notifyListeners();
    });
  }

  @override
  Future<void> signIn() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      print('[ERROR] Failed signing in anonymously: $e');
    }
  }
}
