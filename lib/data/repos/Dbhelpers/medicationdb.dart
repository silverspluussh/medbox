import 'dart:developer';
import 'package:MedBox/domain/models/medication_model.dart';
import 'package:MedBox/main.dart';
import 'package:sqflite/sqflite.dart';

class MedicationsDB {
  static Database? _database;
  static const int _version = 3;
  static const String _colname = 'medications';

  static const String _googlecolname = 'gmedications';

  static Future<void> initDatabase() async {
    if (_database != null) {
      return;
    }
    try {
      bool google = prefs.getBool('googleloggedin') ?? false;

      if (google == false) {
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
      } else if (google == true) {
        String path = '${await getDatabasesPath()}gmedications.db';
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version) {
            log('creating googlemedications db');

            return db.execute('''
              CREATE TABLE $_googlecolname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              medicinename TEXT, dose TEXT, medicinetype TEXT,
               image TEXT
              )''');
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<int> insertmedication(MModel? mmodel) async {
    await initDatabase();
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database?.insert(
            google == false ? _colname : _googlecolname, mmodel!.toJson()) ??
        1;
  }

  Future<int> updatemedicine(MModel mmodel) async {
    await initDatabase();
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _googlecolname, mmodel.toJson(),
        where: 'id =?', whereArgs: [mmodel.id]);
  }

  Future<int> deletemedication(int id) async {
    await initDatabase();
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.delete(google == false ? _colname : _googlecolname,
        where: 'id =?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> querymedication() async {
    await initDatabase();
    bool google = prefs.getBool('googleloggedin') ?? false;

    log('retrieving medicine');
    return await _database!.query(google == false ? _colname : _googlecolname);
  }

  Future<List<MModel>> getmeds() async {
    await initDatabase();
    bool google = prefs.getBool('googleloggedin') ?? false;

    var result =
        await _database!.query(google == false ? _colname : _googlecolname);
    return List.generate(result.length, (i) {
      return MModel.fromJson(result[i]);
    });
  }

  Future<int> addmedController({MModel? mModel}) async {
    await initDatabase();
    return await MedicationsDB.insertmedication(mModel);
  }
}
