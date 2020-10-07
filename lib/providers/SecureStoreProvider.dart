import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStoreProvider {
  static final FlutterSecureStorage _store = FlutterSecureStorage();

  // private constructor to prevent initialization
  SecureStoreProvider._();

  static FlutterSecureStorage get store => _store;
}