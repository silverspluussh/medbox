import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MedBox/main.dart';

class FireBaseCLi {
  Future updatepassword(String password) async {
    if (password.isNotEmpty) {
      await FirebaseAuth.instance.currentUser?.updatePassword(password);
    }
  }

  Future updateEmail(String email) async {
    if (email.isNotEmpty) {
      await FirebaseAuth.instance.currentUser?.updateEmail(email);
    }
  }

  Future sharedpredusername(String username) async {
    await prefs.setString('username', username);
  }

  Future addusername(String usrname) async {
    await FirebaseAuth.instance.currentUser?.updateDisplayName(usrname);
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> getCurrentEmail() async {
    return FirebaseAuth.instance.currentUser?.email!;
  }

  Future resetpassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    await FirebaseAuth.instance.currentUser?.reload();
  }

  // crud for prescription

  static Future<String> addprescription(
      {required String userID, required Map<String, dynamic> datum}) async {
    final document =
        FirebaseFirestore.instance.collection('prescriptions').doc(userID);
    String status = '';

    await document.set(datum).then((value) {
      log("menu is added to firebase cloud store");
    }).catchError((onError) {
      log("Adding presciption error: $onError");
      status = "error";
    }).whenComplete(() {
      status = "success";
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      log('Menu could not be added. Please try again');
      status = "timeout";
    });

    return status;
  }
}
