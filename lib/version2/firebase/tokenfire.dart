import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TokenSave {
  static Future<void> savetoken({required String token}) async {
    FirebaseAuth? user;

    try {
      await FirebaseFirestore.instance
          .collection('users/${user!.currentUser!.uid}/usertokens')
          .doc()
          .set({'token': token}).then(
              (value) => log('token added successfully'));
    } catch (e) {
      log(e.toString());
    }
  }
}
