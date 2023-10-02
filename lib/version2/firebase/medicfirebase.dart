import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/medication_model.dart';

part 'medicfirebase.g.dart';

class MedicationFirebase {
  const MedicationFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  //create medication
  Future<void> addMedication({required MModel med}) =>
      _firestore.collection("medications").add(med.toJson());

//update medication
  Future<void> updateMedication({required MModel med}) =>
      _firestore.collection('medications').doc(med.did!).update(med.toJson());

//delete medication
  Future<void> deleteMedication({required MedID mid}) =>
      _firestore.collection('medications').doc(mid).delete();

// stream all medications

  Stream<List<MModel>> streamMedications() => queryMeds()
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());

  Query<MModel> queryMeds() => _firestore
      .collection('medications')
      .where('mid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .withConverter(
        fromFirestore: (snapshot, _) =>
            MModel.fromJson(snapshot.data()!, mid: snapshot.id),
        toFirestore: (job, _) => job.toJson(),
      );
// fetch medication with future
  Future<List<MModel>> fetchMeds() async {
    final meds = await queryMeds().get();
    return meds.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
MedicationFirebase medicationFirebase(MedicationFirebaseRef ref) =>
    MedicationFirebase(FirebaseFirestore.instance);

@riverpod
Stream<List<MModel>> streamMedications(StreamMedicationsRef ref) {
  final meds = ref.watch(medicationFirebaseProvider);
  return meds.streamMedications();
}
