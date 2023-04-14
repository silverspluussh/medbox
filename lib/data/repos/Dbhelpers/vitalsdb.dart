import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import '../../../domain/models/vitalsmodel.dart';
import '../../../main.dart';

class VitalsDB {
  static Database? _database;
  static const int _version = 2;
  static const String _colname = 'vitals';
  static const String _gcolname = 'gvitals';

  static Future<void> initDatabase() async {
    if (_database != null) {
      return;
    }
    try {
      bool google = prefs.getBool('googleloggedin') ?? false;

      if (google == true) {
        String path = '${await getDatabasesPath()}gvitals.db';
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version) {
            log('creating gvitals db');

            return db.execute('''
              CREATE TABLE $_gcolname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              temperature TEXT, oxygenlevel TEXT, heartrate TEXT, bloodpressure TEXT,
              weight TEXT,height TEXT,bmi TEXT,respiration TEXT
              )''');
          },
        );
      } else if (google == false) {
        String path = '${await getDatabasesPath()}vitals.db';
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version) {
            log('creating vitals db');

            return db.execute('''
              CREATE TABLE $_colname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              temperature TEXT, oxygenlevel TEXT, heartrate TEXT, bloodpressure TEXT,
              weight TEXT,height TEXT,bmi TEXT,respiration TEXT
              )''');
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<int> insertvitals(VModel? vmodel) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database?.insert(
            google == false ? _colname : _gcolname, vmodel!.toJson()) ??
        1;
  }

  static Future<int> updatedatabase(VModel? vmodel) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database?.update(
            google == false ? _colname : _gcolname, vmodel!.toJson(),
            where: 'id=?', whereArgs: [vmodel.id]) ??
        1;
  }

  static Future<List<Map<String, dynamic>>> queryvital() async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    log('retrieving vitals');
    return await _database!.query(google == false ? _colname : _gcolname);
  }

  Future<List<VModel>> getvitals() async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    var result = await _database!.query(google == false ? _colname : _gcolname);
    return List.generate(result.length, (i) {
      return VModel.fromJson(result[i]);
    });
  }

  final model = VModel();

  Future<int> updatetemperature({required String? temp}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _gcolname, {'temperature': temp},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updatebmi({required String? bmi}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _gcolname, {'bmi': bmi},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateglucose({required String? glucose}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _gcolname, {'glucose': glucose},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updaterespiration({required String? respiration}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _gcolname, {'respiration': respiration},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateheartrate({required String? heartrate}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _gcolname, {'heartrate': heartrate},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateheight({required String? height}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _gcolname, {'height': height},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateolevel({required String? oxygenlevel}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _gcolname, {'oxygenlevel': oxygenlevel},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updatepressure({required String? bloodpressure}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(google == false ? _colname : _gcolname,
        {'bloodpressure': bloodpressure},
        where: 'id=?', whereArgs: [model.id]);
  }
}
