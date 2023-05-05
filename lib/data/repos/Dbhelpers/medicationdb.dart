import 'dart:developer';
import 'package:MedBox/domain/models/medication_model.dart';
import 'package:MedBox/main.dart';
import 'package:sqflite/sqflite.dart';
import '../../../domain/sharedpreferences/sharedprefs.dart';

class MedicationsDB {
  static Database _database;
  static const int _version = 3;
  static const String _colname = 'medications';

  Future<void> initDatabase() async {
    if (_database != null &&
        prefs.getString('uid') == SharedCli().getuserID()) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}medications.db';
      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          log('creating medications db');

          return db.execute('''
              CREATE TABLE $_colname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              medicinename TEXT, dose TEXT, medicinetype TEXT,
               image TEXT
              )''');
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> insertmedication(MModel mmodel) async {
    return await _database?.insert(_colname, mmodel.toJson()) ?? 1;
  }

  Future<int> updatemedicine(MModel mmodel) async {
    return await _database.update(_colname, mmodel.toJson(),
        where: 'id =?', whereArgs: [mmodel.id]);
  }

  Future<int> deletemedication(int id) async {
    return await _database.delete(_colname, where: 'id =?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> querymedication() async {
    log('retrieving medicine');
    return await _database.query(_colname);
  }

  Future<List<MModel>> getmeds() async {
    await initDatabase();
    var result = await _database.query(_colname);
    return List.generate(result.length, (i) {
      return MModel.fromJson(result[i]);
    });
  }

  Future<int> addmedController({MModel mModel}) async {
    return await MedicationsDB().insertmedication(mModel);
  }
}
