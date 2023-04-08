import 'package:firebase_auth/firebase_auth.dart';
import 'package:MedBox/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirestoreAuth {
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
}
