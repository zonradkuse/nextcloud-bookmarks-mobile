import 'package:bookmarks/models/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static Database _database;

  // empty private constructor to prevent initialization
  DatabaseProvider._private();

  static Future<Database> get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  static Future<Database> _initDatabase() async {
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), "nextcloud_bookmarks.db"),

      // Create schema of database
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ${User.TABLE_NAME}(${User.COLUMN_NAME_USER_NAME} TEXT, ${User.COLUMN_NAME_SERVER_BASE_URL} TEXT)",
        );
      },
      // use downgrade to clear the database
      onDowngrade: (db, versionOld, versionNew) {
        return db.execute(
          "DELETE FROM ${User.TABLE_NAME};"
        );
      },
      version: 1,
    );

    return database;
  }
}