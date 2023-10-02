import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TokenSave {
  static Future<void> savetoken({required String token}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "pEmail": FirebaseAuth.instance.currentUser!.email,
        "fullname": FirebaseAuth.instance.currentUser!.displayName,
        "token": token,
        "id": FirebaseAuth.instance.currentUser!.uid
      }).then((value) => log('token saved'));
    } catch (e) {
      log(e.toString());
    }
  }
}
