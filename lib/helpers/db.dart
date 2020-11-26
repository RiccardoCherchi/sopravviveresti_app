import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DB {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'sopravviveresti.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE user_fav(id INT PRIMARY KEY, situation TEXT, explanation TEXT)",
        );

        await db.execute(
          "CREATE TABLE hearts(id INT PRIMARY KEY, amount INT)",
        );

        await db.execute(
          "CREATE TABLE hearts_time(id INT PRIMARY KEY, date TEXT)",
        );

        final date = DateTime.now().toUtc().add(Duration(days: 1));

        await db.insert('hearts', {"id": 1, "amount": 5});
        await db
            .insert("hearts_time", {"id": 1, "date": date.toIso8601String()});
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print(oldVersion);
        if (newVersion == 2) {
          await db.execute(
            "CREATE TABLE IF NOT EXISTS hearts(id INT PRIMARY KEY, amount INT)",
          );

          await db.execute(
            "CREATE TABLE IF NOT EXISTS hearts_time(id INT PRIMARY KEY, date TEXT)",
          );

          final date = DateTime.now().toUtc().add(Duration(days: 1));

          await db.insert('hearts', {"id": 1, "amount": 5},
              conflictAlgorithm: sql.ConflictAlgorithm.ignore);
          await db.insert(
              "hearts_time", {"id": 1, "date": date.toIso8601String()},
              conflictAlgorithm: sql.ConflictAlgorithm.ignore);
        }
      },
    );
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

  static Future updateById(
      String table, int id, Map<String, dynamic> data) async {
    final db = await DB.database();
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }
}
