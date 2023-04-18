import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import '../../../domain/models/vitalsmodel.dart';
import '../../../main.dart';

class VitalsDB {
  static Database? _database;
  static const int _version = 2;
  static const String _colname = 'vitals';
  static const String _gcolname = 'gvitals';

  bool goog = prefs.getBool('googleloggedin') ?? false;

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
              temperature TEXT, oxygenlevel TEXT, heartrate TEXT, bloodpressure TEXT,day STRING,
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
              temperature TEXT, oxygenlevel TEXT, heartrate TEXT, bloodpressure TEXT,day TEXT,
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

  Future<int> updateweight({required String? weight}) async {
    bool google = prefs.getBool('googleloggedin') ?? false;

    return await _database!.update(
        google == false ? _colname : _gcolname, {'weight': weight},
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

  Future<List<Map<String, dynamic>>> avgquery() async {
    return _database!.rawQuery(
        'SELECT AVG(temperature) AS temperature, AVG(bloodpressure) AS bloodpressure, AVG(heartrate) AS heartrate,  AVG(oxygenlevel) AS oxygenlevel  FROM ${goog == true ? _gcolname : _colname};');
  }

  Future<List<Map<String, dynamic>>> maxquery() async {
    return _database!.rawQuery(
        'SELECT MAX(temperature) AS temperature, MAX(bloodpressure) AS bloodpressure, MAX(heartrate) AS heartrate,  MAX(oxygenlevel) AS oxygenlevel  FROM ${goog == true ? _gcolname : _colname};');
  }

  Future<List<Map<String, dynamic>>> minquery() async {
    return _database!.rawQuery(
        'SELECT MIN(temperature) AS temperature, MIN(bloodpressure) AS bloodpressure, MIN(heartrate) AS heartrate,  MIN(oxygenlevel) AS oxygenlevel  FROM ${goog == true ? _gcolname : _colname};');
  }

  Future<List<Map<String, dynamic>>> weeklyreadings({required day}) async {
    return _database!.rawQuery(
      '''
       SELECT 
          temperature,bloodpressure,oxygenlevel,respiration,heartrate,day
       FROM 
          $_colname
       WHERE
          day = '$day';
       ''',
    );
  }
}
