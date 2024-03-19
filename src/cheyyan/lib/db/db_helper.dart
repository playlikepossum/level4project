import 'package:cheyyan/models/abilities.dart';
import 'package:cheyyan/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tasksTableName = "tasks";
  static const String _abilitiesTableName = "abilities";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}tasks.db';
      deleteDatabase(path);
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          print("creating a new db");

          // Create tasks table
          await db.execute(
            "CREATE TABLE $_tasksTableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER,"
            "type STRING)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insertTask(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tasksTableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> queryTasks() async {
    print("query tasks function called");
    return await _db!.query(
      _tasksTableName,
      orderBy: 'date ASC, startTime ASC',
    );
  }

  static Future<int> insertAbilities(Abilities? abilities) async {
    print("insert abilities function called");
    return await _db?.insert(_abilitiesTableName, abilities!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> queryAbilities() async {
    print("query abilities function called");
    List<Map<String, dynamic>> results = await _db!.query(_abilitiesTableName);
    return results;
  }

  static deleteTask(Task task) async {
    return await _db!
        .delete(_tasksTableName, where: 'id=?', whereArgs: [task.id]);
  }

  static updateTaskCompletion(int id) async {
    return await _db!.rawUpdate('''
      UPDATE $_tasksTableName
      SET isCompleted = ?
      WHERE id = ?
''', [1, id]);
  }

  static Future<String?> getTaskType(int id) async {
    List<Map<String, dynamic>> result = await _db!.query(
      _tasksTableName,
      columns: ['type'],
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first['type'] : null;
  }

  static updateTaskType(int id, String type) async {
    return await _db!.rawUpdate('''
      UPDATE $_tasksTableName
      SET type = ?
      WHERE id = ?
''', [type, id]);
  }

  static updateAbilities(String ability, int score) async {
    return await _db!.rawUpdate('''
      UPDATE $_abilitiesTableName
      SET ? = ?
      
''', [ability, score]);
  }
}
