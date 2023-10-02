import 'package:MedBox/version2/models/profilemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profilefirebase.g.dart';

class ProfileFirebase {
  const ProfileFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addProfile({required ProfileModel med}) => _firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set(med.toJson());

  Future<void> updateProfile({required ProfileModel med}) => _firestore
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update(med.toJson());

  Future<void> delProfile() => _firestore
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .delete();

  Stream<ProfileModel> getSingleProfile() {
    return _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snap, _) =>
                ProfileModel.fromJson(tid: snap.id, snap.data()!),
            toFirestore: (snap, _) => {})
        .snapshots()
        .map((event) => event.data()!);
  }
}

@Riverpod(keepAlive: true)
ProfileFirebase profileFirebase(ProfileFirebaseRef ref) =>
    ProfileFirebase(FirebaseFirestore.instance);
