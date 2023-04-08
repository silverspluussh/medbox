import 'dart:developer';
import 'package:MedBox/components/patient/medications/remModel.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';

class ReminderDB {
  static Database? _database;
  static const int _version = 3;
  static const String _colname = 'reminders';
  static const String _gcolname = 'greminders';

  static Future<void> initDatabase() async {
    if (_database != null) {
      return;
    }
    try {
      bool google = prefs.getBool('googleloggedin') ?? false;

      if (google == false) {
        String path = '${await getDatabasesPath()}reminders.db';
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version) {
            log('creating reminders db');

            return db.execute('''
              CREATE TABLE $_colname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              medicinename TEXT, timeformat TEXT,setdate TEXT, status TEXT
              )''');
          },
        );
      } else if (google == true) {
        String path = '${await getDatabasesPath()}greminders.db';
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version) {
            log('creating greminders db');

            return db.execute('''
              CREATE TABLE $_gcolname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              medicinename TEXT, timeformat TEXT,setdate TEXT, status TEXT
              )''');
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<int> insertreminder(RModel? rmodel) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database?.insert(
            google == false ? _colname : _gcolname, rmodel!.toJson()) ??
        1;
  }

  static Future<List<Map<String, dynamic>>> qreminder() async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    log('retrieving reminders');
    return await _database!.query(google == false ? _colname : _gcolname);
  }

  Future<List<RModel>> getremdinder() async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    var result = await _database!.query(google == false ? _colname : _gcolname);
    return List.generate(result.length, (i) {
      return RModel.fromJson(result[i]);
    });
  }

  Future<int> addremindertroller({RModel? rModel}) async {
    return await ReminderDB.insertreminder(rModel);
  }
}
