import 'dart:developer';
import 'package:MedBox/domain/models/prescribemodel.dart';
import 'package:sqflite/sqflite.dart';
import '../../../domain/sharedpreferences/sharedprefs.dart';
import '../../../main.dart';

class PrescriptionDB {
  static Database? _database;
  static const int _version = 6;
  static const String _colname = 'prescriptions';

  Future<void> initDatabase() async {
    if (_database != null &&
        prefs.getString('uid') == SharedCli().getuserID()) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}prescriptions.db';
      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          log('creating prescriptions db');

          return db.execute('''
              CREATE TABLE $_colname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,fileimagepath TEXT,
              datetime TEXT        
              )''');
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> addprescription(PrescModel ppmodel) async {
    return await _database?.insert(_colname, ppmodel.toJSON()) ?? 1;
  }

  Future<int> addpres({required PrescModel ppModel}) async {
    return await PrescriptionDB().addprescription(ppModel);
  }

  Future<int> removePrescription(int id) async {
    return await _database!.delete(_colname, where: 'id =?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getprescribe() async {
    log('retrieving prescriptions');
    return await _database!.query(_colname);
  }

  Future<List<PrescModel>> getprescription() async {
    var result = await _database!.query(_colname);
    return List.generate(result.length, (i) {
      return PrescModel.fromJson(result[i]);
    });
  }
}
