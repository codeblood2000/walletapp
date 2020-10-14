import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database(String table) async {
    final dbPath = await sql.getDatabasesPath();
    if (table == 'parties') {
      return sql.openDatabase(path.join(dbPath, 'party.db'),
          onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE parties(id TEXT PRIMARY KEY, name TEXT, mobile TEXT, address TEXT)');
      }, version: 1);
    } else if (table == 'records') {
      return sql.openDatabase(path.join(dbPath, 'record.db'),
          onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE records(id TEXT PRIMARY KEY, name TEXT, amount INTEGER ,remark TEXT, type TEXT, date TEXT)');
      }, version: 1);
    }
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database(table);
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database(table);
    return db.query(table);
  }
}
