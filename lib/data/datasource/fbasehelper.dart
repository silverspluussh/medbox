import 'package:MedBox/domain/models/rapidtestmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  static Stream<List<PharmacyModel>> pharmacies() => FirebaseFirestore.instance
      .collection('pharmacies')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PharmacyModel.fromJson(doc.data()))
          .toList());

  static Stream<List<RapidtestModel>> rapids() => FirebaseFirestore.instance
      .collection('rapidtests')
      .where('0557466718', isEqualTo: 'patientcontact')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => RapidtestModel.fromJson(doc.data()))
          .toList());
}
