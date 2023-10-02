import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/vitalsmodel.dart';

part 'vitalsfirebase.g.dart';

class VitalsFirebase {
  const VitalsFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  static String rPath(String vid) => 'vitals/$vid';
  static String rsPath() => 'vitals';

  Future<void> addVital({required String uid, required VModel test}) =>
      _firestore.collection(rsPath()).add(test.toJson());

  Future<void> updateVital({required VModel model}) =>
      _firestore.doc(rPath(model.vid!)).update(model.toJson());

  Stream<List<VModel>> streamVitals() => queryVitals()
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());

  Query<VModel> queryVitals() => _firestore
      .collection(rsPath())
      .where("vid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .withConverter(
        fromFirestore: (snapshot, options) =>
            VModel.fromJson(snapshot.data()!, tid: snapshot.id),
        toFirestore: (job, options) => job.toJson(),
      )
      .orderBy('createdAt', descending: true);
  Future<List<VModel>> fetchVitals({required String uid}) async {
    final p = await queryVitals().get();
    return p.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
VitalsFirebase vitalsFirebase(VitalsFirebaseRef ref) =>
    VitalsFirebase(FirebaseFirestore.instance);

@riverpod
Stream<List<VModel>> vitalsStream(VitalsStreamRef ref) {
  final vitalsRepo = ref.watch(vitalsFirebaseProvider);
  return vitalsRepo.streamVitals();
}
