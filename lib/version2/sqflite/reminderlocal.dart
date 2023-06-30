import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../utilites/sharedprefs.dart';
import '../models/reminders_model.dart';

part 'reminderlocal.g.dart';

class RemindersDb {
  static Database? _db;
  static const int _v = 1;
  static const String _dbname = 'reminders';
  FirebaseAuth? user;
  final uid = SharedCli().getuserID();

  Future<void> remindersInit() async {
    if (_db != null && user!.currentUser!.uid == uid) {
      return;
    }

    try {
      String path = '${await getDatabasesPath()}reminders.db';
      _db = await openDatabase(
        path,
        version: _v,
        onCreate: (db, version) {
          log('creating reminders db');

          return db.execute('''
              CREATE TABLE $_dbname (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              medicinename TEXT, time TEXT,date TEXT,body TEXT
              )''');
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> addReminder(RModel model) async =>
      await _db?.insert(_dbname, model.toJson()) ?? 1;

  Future<List<RModel>> fetchReminders() async {
    var reminders = await _db!.query(_dbname);
    log('retrieved reminders');

    return List.generate(
        reminders.length, (i) => RModel.fromJson(reminders[i]));
  }

  Future<int> delReminder(int id) async {
    try {
      await _db!.delete(_dbname, where: 'id =?', whereArgs: [id]);
      log('deleted reminder at $id');
    } catch (e) {
      log(e.toString());
    }
    return 1;
  }
}

@Riverpod(keepAlive: true)
RemindersDb remindersDb(RemindersDbRef ref) => RemindersDb();
