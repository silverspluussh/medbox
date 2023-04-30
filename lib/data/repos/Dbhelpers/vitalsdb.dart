import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import '../../../domain/models/vitalsmodel.dart';
import '../../../domain/sharedpreferences/sharedprefs.dart';
import '../../../main.dart';

class VitalsDB {
  static Database? _database;
  static const int _version = 2;
  static const String _colname = 'vitals';

  Future<void> initDatabase() async {
    if (_database != null &&
        prefs.getString('uid') == SharedCli().getuserID()) {
      return;
    }
    try {
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
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> insertvitals(VModel? vmodel) async {
    return await _database?.insert(_colname, vmodel!.toJson()) ?? 1;
  }

  Future<int> updatedatabase(VModel? vmodel) async {
    return await _database?.update(_colname, vmodel!.toJson(),
            where: 'id=?', whereArgs: [vmodel.id]) ??
        1;
  }

  Future<List<Map<String, dynamic>>> queryvital() async {
    log('retrieving vitals');
    return await _database!.query(_colname);
  }

  Future<List<VModel>> getvitals() async {
    var result = await _database!.query(_colname);
    return List.generate(result.length, (i) {
      return VModel.fromJson(result[i]);
    });
  }

  final model = VModel();

  Future<int> updatetemperature({required String? temp}) async {
    return await _database!.update(_colname, {'temperature': temp},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updatebmi({required String? bmi}) async {
    return await _database!
        .update(_colname, {'bmi': bmi}, where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateglucose({required String? glucose}) async {
    return await _database!.update(_colname, {'glucose': glucose},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updaterespiration({required String? respiration}) async {
    return await _database!.update(_colname, {'respiration': respiration},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateheartrate({required String? heartrate}) async {
    return await _database!.update(_colname, {'heartrate': heartrate},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateheight({required String? height}) async {
    return await _database!.update(_colname, {'height': height},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateweight({required String? weight}) async {
    return await _database!.update(_colname, {'weight': weight},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updateolevel({required String? oxygenlevel}) async {
    return await _database!.update(_colname, {'oxygenlevel': oxygenlevel},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<int> updatepressure({required String? bloodpressure}) async {
    return await _database!.update(_colname, {'bloodpressure': bloodpressure},
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<List<Map<String, dynamic>>> avgquery() async {
    return _database!.rawQuery(
        'SELECT AVG(temperature) AS temperature, AVG(bloodpressure) AS bloodpressure, AVG(heartrate) AS heartrate,  AVG(oxygenlevel) AS oxygenlevel,AVG(respiration) AS respiration  FROM  $_colname};');
  }

  Future<List<Map<String, dynamic>>> maxquery() async {
    return _database!.rawQuery(
        'SELECT MAX(temperature) AS temperature, MAX(bloodpressure) AS bloodpressure, MAX(heartrate) AS heartrate,  MAX(oxygenlevel) AS oxygenlevel,MAX(respiration) AS respiration  FROM $_colname;');
  }

  Future<List<Map<String, dynamic>>> minquery() async {
    return _database!.rawQuery('''SELECT 
              MIN(temperature) AS temperature,
              MIN(bloodpressure) AS bloodpressure, 
              MIN(heartrate) AS heartrate,  
              MIN(oxygenlevel) AS oxygenlevel,
              MIN(respiration) AS respiration  
           FROM 
              $_colname;
        ''');
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
