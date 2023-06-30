import 'package:MedBox/version2/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/pharmacymodel.dart';

part 'pharmfirebase.g.dart';

class PharmacyFirebase {
  const PharmacyFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  static String pharmacyPath(UserID uid, Pid pid) => 'users/$uid/pharmacy/$pid';
  static String pharmsPath(String uid) => 'users/$uid/pharmacy';

  //create Pharmacy
  Future<void> addPharmacy(
          {required String uid, required PharmacyModel pharm}) =>
      _firestore.collection(pharmsPath(uid)).add(pharm.toJson());

//update Pharmacy
  Future<void> updatePharmacy(
          {required String uid, required PharmacyModel model}) =>
      _firestore.doc(pharmacyPath(uid, model.pid!)).update(model.toJson());

  Future<void> deletePharmacy(
          {required String uid, required PharmacyModel model}) =>
      _firestore.doc(pharmacyPath(uid, model.pid!)).delete();

  Stream<PharmacyModel> streamPharmacy(
          {required String uid, required PharmacyModel med}) =>
      _firestore
          .doc(pharmacyPath(uid, med.pid!))
          .withConverter(
              fromFirestore: (snap, _) => PharmacyModel.fromJson(snap.data()!),
              toFirestore: (snap, _) => med.toJson())
          .snapshots()
          .map((event) => event.data()!);

  Stream<List<PharmacyModel>> streamPharmacys({required String uid}) =>
      queryPharmacys(uid: uid)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());

  Query<PharmacyModel> queryPharmacys({required String uid}) =>
      _firestore.collection(pharmsPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                PharmacyModel.fromJson(snapshot.data()!),
            toFirestore: (job, _) => job.toJson(),
          );
// fetch medication with future
  Future<List<PharmacyModel>> fetchPharmacys({required String uid}) async {
    final p = await queryPharmacys(uid: uid).get();
    return p.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
PharmacyFirebase pharmacyFirebase(PharmacyFirebaseRef ref) =>
    PharmacyFirebase(FirebaseFirestore.instance);
