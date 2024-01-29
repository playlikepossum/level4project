import 'package:cheyyan/models/abilities.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper2 {
  static Database? _db;
  static const int _version = 2;

  static const String _abilitiesTableName = "abilities";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}abilities.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          print("creating a new db");

          // Create tasks table

          // Create abilities table
          await db.execute('''
      CREATE TABLE $_abilitiesTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        strength INTEGER DEFAULT 10 NOT NULL,
        intelligence INTEGER DEFAULT 10 NOT NULL,
        charisma INTEGER DEFAULT 10 NOT NULL,
        constitution INTEGER DEFAULT 10 NOT NULL
      )
    ''');
          await db.execute('''
      INSERT INTO $_abilitiesTableName 
      (strength, intelligence, charisma, constitution)
      VALUES (10, 10, 10, 10)
    ''');
        },
      );
    } catch (e) {
      print(e);
    }
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

  static updateAbilities(String ability, int score) async {
    return await _db!.rawUpdate('''
    UPDATE $_abilitiesTableName
    SET $ability = ?
    WHERE id = 1
  ''', [score]);
  }

  static incrementAbilities(String ability) async {
    return await _db!.rawUpdate(
      '''
    UPDATE $_abilitiesTableName
    SET $ability = $ability + 1
    WHERE id = 1
  ''',
    );
  }
}
