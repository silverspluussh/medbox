import 'dart:developer';
import 'package:MedBox/components/profile/pmodel.dart';
import 'package:sqflite/sqflite.dart';

class ProfileDB {
  static Database? _database;
  static const int _version = 3;
  static const String _colname = 'profile';

  static Future<void> initDatabase() async {
    if (_database != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}profile.db';
      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          log('creating profile db');

          return db.execute('''
              CREATE TABLE $_colname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              fname TEXT, lname TEXt, dob TEXt,
              email TEXT ,username TEXT
            
              )''');
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<int> insertmedication(PModel? mmodel) async {
    return await _database?.insert(_colname, mmodel!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> querymedication() async {
    log('retrieving profile');
    return await _database!.query(_colname);
  }

  static Future<int> updateprofile(PModel? pmodel) async {
    return await _database?.update(_colname, pmodel!.toJson(),
            where: 'id=?', whereArgs: [pmodel.id]) ??
        1;
  }
}
