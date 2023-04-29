import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MedBox/main.dart';

import '../../domain/models/pharmacymodel.dart';

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
  static Stream<List<PharmacyModel>> pharmcies() => FirebaseFirestore.instance
      .collection('pharmacies')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PharmacyModel.fromJson(doc.data()))
          .toList());
}
