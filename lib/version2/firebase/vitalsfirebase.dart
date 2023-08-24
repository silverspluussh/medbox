import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/usermodel.dart';
import '../models/vitalsmodel.dart';
import '../providers.dart/authprovider.dart';

part 'vitalsfirebase.g.dart';

class VitalsFirebase {
  const VitalsFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  static String rPath(UserID uid, String vid) => 'users/$uid/vitals/$vid';
  static String rsPath(UserID uid) => 'users/$uid/vitals';

  Future<void> addVital({required String uid, required VModel test}) =>
      _firestore.collection(rsPath(uid)).add(test.toJson());

  Future<void> updateVital({required String uid, required VModel model}) =>
      _firestore.doc(rPath(uid, model.vid!)).update(model.toJson());

  Stream<List<VModel>> streamVitals({required String uid}) =>
      queryVitals(uid: uid)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());

  Query<VModel> queryVitals({required String uid}) => _firestore
      .collection(rsPath(uid))
      .withConverter(
        fromFirestore: (snapshot, options) =>
            VModel.fromJson(snapshot.data()!, tid: snapshot.id),
        toFirestore: (job, options) => job.toJson(),
      )
      .orderBy('createdAt', descending: true);
  Future<List<VModel>> fetchVitals({required String uid}) async {
    final p = await queryVitals(uid: uid).get();
    return p.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
VitalsFirebase vitalsFirebase(VitalsFirebaseRef ref) =>
    VitalsFirebase(FirebaseFirestore.instance);

@riverpod
Stream<List<VModel>> vitalsStream(VitalsStreamRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  final vitalsRepo = ref.watch(vitalsFirebaseProvider);
  return vitalsRepo.streamVitals(uid: user!.uid);
}
