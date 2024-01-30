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
      // deleteDatabase(path);
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
        strength INTEGER DEFAULT 5 NOT NULL,
        intelligence INTEGER DEFAULT 5 NOT NULL,
        charisma INTEGER DEFAULT 5 NOT NULL,
        constitution INTEGER DEFAULT 5 NOT NULL,
        strprogress REAL DEFAULT 0.0 NOT NULL,
        intprogress REAL DEFAULT 0.0 NOT NULL,
        chrprogress REAL DEFAULT 0.0 NOT NULL,
        conprogress REAL DEFAULT 0.0 NOT NULL
      )
    ''');
          await db.execute('''
      INSERT INTO $_abilitiesTableName 
      (strength, intelligence, charisma, constitution,strprogress,intprogress, chrprogress, conprogress )
      VALUES (5, 5, 5, 5, 0.0,0.0,0.0,0.0)
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

  static Future<double?> getProgress(String ability) async {
    if (ability == 'strength') {
      List<Map<String, dynamic>> result = await _db!.query(
        _abilitiesTableName,
        columns: ['strprogress'],
        where: 'id = ?',
        whereArgs: [1],
      );
      return result.isNotEmpty ? result.first['strprogress'] as double : null;
    }
    if (ability == 'intelligence') {
      List<Map<String, dynamic>> result = await _db!.query(
        _abilitiesTableName,
        columns: ['intprogress'],
        where: 'id = ?',
        whereArgs: [1],
      );
      return result.isNotEmpty ? result.first['intprogress'] as double : null;
    }
    if (ability == 'charisma') {
      List<Map<String, dynamic>> result = await _db!.query(
        _abilitiesTableName,
        columns: ['chrprogress'],
        where: 'id = ?',
        whereArgs: [1],
      );
      return result.isNotEmpty ? result.first['chrprogress'] as double : null;
    }
    if (ability == 'constitution') {
      List<Map<String, dynamic>> result = await _db!.query(
        _abilitiesTableName,
        columns: ['conprogress'],
        where: 'id = ?',
        whereArgs: [1],
      );
      return result.isNotEmpty ? result.first['conprogress'] as double : null;
    }
  }

  static incrProgress(String ability) async {
    if (ability == 'strength') {
      return await _db!.rawUpdate(
        '''
    UPDATE $_abilitiesTableName
    SET strprogress = strprogress + 0.1
    WHERE id = 1
  ''',
      );
    }
    if (ability == 'intelligence') {
      return await _db!.rawUpdate(
        '''
    UPDATE $_abilitiesTableName
    SET intprogress = intprogress + 0.2
    WHERE id = 1
  ''',
      );
    }
    if (ability == 'charisma') {
      return await _db!.rawUpdate(
        '''
    UPDATE $_abilitiesTableName
    SET chrprogress = chrprogress + 0.2
    WHERE id = 1
  ''',
      );
    }
    if (ability == 'constitution') {
      return await _db!.rawUpdate(
        '''
    UPDATE $_abilitiesTableName
    SET conprogress = conprogress + 0.1
    WHERE id = 1
  ''',
      );
    }
  }

  static incrementAbilities(String ability) async {
    incrProgress(ability);
    double? progress = await DBHelper2.getProgress(ability);
    if (progress != null && progress >= 1) {
      print('hello');
      resetProgress(ability);
      return await _db!.rawUpdate(
        '''
      UPDATE $_abilitiesTableName
      SET $ability = $ability + 1
      WHERE id = 1
    ''',
      );
    }
  }

  static resetProgress(String ability) async {
    if (ability == 'strength') {
      return await _db!.rawUpdate(
        '''
    UPDATE $_abilitiesTableName
    SET strprogress = 0
    WHERE id = 1
  ''',
      );
    }
    if (ability == 'intelligence') {
      return await _db!.rawUpdate(
        '''
    UPDATE $_abilitiesTableName
    SET intprogress = 0
    WHERE id = 1
  ''',
      );
    }
    if (ability == 'charisma') {
      return await _db!.rawUpdate(
        '''
    UPDATE $_abilitiesTableName
    SET chrprogress = 0
    WHERE id = 1
  ''',
      );
    }
    if (ability == 'constitution') {
      return await _db!.rawUpdate(
        '''
    UPDATE $_abilitiesTableName
    SET conprogress = 0
    WHERE id = 1
  ''',
      );
    }
  }
}
