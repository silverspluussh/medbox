import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/medication_model.dart';
import '../providers.dart/authprovider.dart';

part 'medicfirebase.g.dart';

class MedicationFirebase {
  const MedicationFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  static String medicationPath(String uid, String medID) =>
      'users/$uid/medications/$medID';
  static String medsPath(String uid) => 'users/$uid/medications';

  //create medication
  Future<void> addMedication({required String uid, required MModel med}) =>
      _firestore.collection(medsPath(uid)).add(med.toJson());

//update medication
  Future<void> updateMedication({required String uid, required MModel med}) =>
      _firestore.doc(medicationPath(uid, med.mid!)).update(med.toJson());

//delete medication
  Future<void> deleteMedication({required String uid, required MedID mid}) =>
      _firestore.doc(medicationPath(uid, mid)).delete();

//watch medication and medications through stream

  Stream<MModel> streamMedication({required String uid, required MModel med}) =>
      _firestore
          .doc(medicationPath(uid, med.mid!))
          .withConverter(
              fromFirestore: (snap, _) =>
                  MModel.fromJson(snap.data()!, mid: snap.id),
              toFirestore: (snap, _) => med.toJson())
          .snapshots()
          .map((event) => event.data()!);

// stream all medications

  Stream<List<MModel>> streamMedications({required String uid}) =>
      queryMeds(uid: uid)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());

  Query<MModel> queryMeds({required String uid}) =>
      _firestore.collection(medsPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                MModel.fromJson(snapshot.data()!, mid: snapshot.id),
            toFirestore: (job, _) => job.toJson(),
          );
// fetch medication with future
  Future<List<MModel>> fetchMeds({required String uid}) async {
    final meds = await queryMeds(uid: uid).get();
    return meds.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
MedicationFirebase medicationFirebase(MedicationFirebaseRef ref) =>
    MedicationFirebase(FirebaseFirestore.instance);

@riverpod
Stream<List<MModel>> streamMedications(StreamMedicationsRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  final meds = ref.watch(medicationFirebaseProvider);
  return meds.streamMedications(uid: user!.uid);
}
