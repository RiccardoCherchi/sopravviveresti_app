import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DB {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'sopravviveresti.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_fav(id INT PRIMARY KEY, situation TEXT, explanation TEXT)');
    }, version: 1);
  }

  static Future insert(String table, Map<String, Object> data) async {
    final db = await DB.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DB.database();
    return db.query(table);
  }

  static Future delete(String table, int id) async {
    final db = await DB.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future filterById(String table, int id) async {
    final db = await DB.database();
    return db.rawQuery('select * from $table where id = $id');
  }
}
