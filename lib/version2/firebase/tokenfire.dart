import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TokenSave {
  static Future<void> savetoken({required String token}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('usertokens')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}).then((value) => log('token saved'));
    } catch (e) {
      log(e.toString());
    }
  }
}
