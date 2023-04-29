import 'dart:developer';
import 'package:MedBox/domain/models/prescribemodel.dart';
import 'package:sqflite/sqflite.dart';
import '../../../domain/sharedpreferences/profileshared.dart';

class PrescriptionDB {
  static Database? _database;
  static const int _version = 6;
  static const String _colname = 'prescriptions';

  static const String _googlecolname = 'gprescriptions';

  static Future<void> initDatabase() async {
    if (_database != null) {
      return;
    }
    try {
      bool google = SharedCli().getgmailstatus() ?? false;

      if (google == false) {
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
      } else if (google == true) {
        String path = '${await getDatabasesPath()}gprescriptions.db';
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version) {
            log('creating googleprescriptions db');

            return db.execute('''
              CREATE TABLE $_googlecolname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,fileimagepath TEXT, 
              datetime TEXT 
              )''');
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<int> addprescription(PrescModel ppmodel) async {
    await initDatabase();
    bool google = SharedCli().getgmailstatus() ?? false;

    return await _database?.insert(
            google == false ? _colname : _googlecolname, ppmodel.toJSON()) ??
        1;
  }

  Future<int> addpres({required PrescModel ppModel}) async {
    await initDatabase();
    return await PrescriptionDB.addprescription(ppModel);
  }

  Future<int> removePrescription(int id) async {
    await initDatabase();
    bool google = SharedCli().getgmailstatus() ?? false;

    return await _database!.delete(google == false ? _colname : _googlecolname,
        where: 'id =?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getprescribe() async {
    await initDatabase();
    bool google = SharedCli().getgmailstatus() ?? false;

    log('retrieving prescriptions');
    return await _database!.query(google == false ? _colname : _googlecolname);
  }

  Future<List<PrescModel>> getprescription() async {
    await initDatabase();
    bool google = SharedCli().getgmailstatus() ?? false;

    var result =
        await _database!.query(google == false ? _colname : _googlecolname);
    return List.generate(result.length, (i) {
      return PrescModel.fromJson(result[i]);
    });
  }
}
