// ignore_for_file: file_names

import 'dart:developer';
import 'package:MedBox/domain/models/reminders_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/sharedpreferences/sharedprefs.dart';
import '../../../main.dart';

class ReminderDB {
  static Database? _database;
  static const int _version = 3;
  static const String _colname = 'reminders';

  Future<void> initDatabase() async {
    if (_database != null &&
        prefs.getString('uid') == SharedCli().getuserID()) {
      return;
    }
    try {
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
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> insertreminder(RModel rmodel) async {
    return await _database?.insert(_colname, rmodel.toJson()) ?? 1;
  }

  Future<List<Map<String, dynamic>>> qreminder() async {
    log('retrieving reminders');
    return await _database!.query(_colname);
  }

  Future<List<RModel>> getremdinder() async {
    var result = await _database!.query(_colname);
    return List.generate(result.length, (i) {
      return RModel.fromJson(result[i]);
    });
  }

  Future<int> addremindertroller({RModel? rModel}) async {
    return await ReminderDB().insertreminder(rModel!);
  }
}
