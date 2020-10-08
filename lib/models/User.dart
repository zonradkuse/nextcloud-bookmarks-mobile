import 'package:bookmarks/providers/DatabaseProvider.dart';
import 'package:bookmarks/providers/SecureStoreProvider.dart';
import 'package:sqflite/sqflite.dart';

class User {

  static const TABLE_NAME = "USER";
  static const COLUMN_NAME_SERVER_BASE_URL = "BASE_URL";
  static const COLUMN_NAME_USER_NAME = "USER_NAME";

  static const PREFIX_PW_KEY = "NCBookmars_";

  String _serverBaseUrl;

  String _username;

  // This password is unique to our app and stored outside of sql but in a secure store instead!
  String _appPassword;

  String get appPassword => _appPassword;
  String get serverUrl => _serverBaseUrl;
  String get username => _username;

  User(this._serverBaseUrl, this._username, this._appPassword);

  Map<String, dynamic> toMap() {
    return {
      COLUMN_NAME_SERVER_BASE_URL: this._serverBaseUrl,
      COLUMN_NAME_USER_NAME: this._username
    };
  }

  Future<User> insert() async {
    final Database db = await DatabaseProvider.database;
    SecureStoreProvider.store.write(
        key: "${PREFIX_PW_KEY}_${_serverBaseUrl}_$_username",
        value: this._appPassword
    );

    await db.insert(
      TABLE_NAME,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore
    );

    return this;
  }

  static Future<User> findOne() async {
    Database db = await DatabaseProvider.database;

    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME, limit: 1);

    // no user found!
    if (maps.length == 0) return null;

    var serverUrl = maps.first[COLUMN_NAME_SERVER_BASE_URL];
    var username = maps.first[COLUMN_NAME_USER_NAME];
    String password = await SecureStoreProvider.store.read(key: "${PREFIX_PW_KEY}_${serverUrl}_$username");

    return User(serverUrl, username, password);
  }

  static User empty() {
    return User(null, null, null);
  }
}