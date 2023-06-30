import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/prescribemodel.dart';
import '../models/usermodel.dart';

part 'prescfirebase.g.dart';

class PrescFirebase {
  const PrescFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  static String path(UserID uid, String pid) => 'users/$uid/prescriptions/$pid';
  static String paths(String uid) => 'users/$uid/prescriptions';

  //create prescription
  Future<void> addPrescription(
          {required String uid, required PrescModel model}) =>
      _firestore.collection(paths(uid)).add(model.toJSON());

  Query<PrescModel> query({required String uid}) =>
      _firestore.collection(paths(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                PrescModel.fromJson(snapshot.data()!),
            toFirestore: (job, _) => job.toJSON(),
          );

// fetch prescriptions with future
  Future<List<PrescModel>> fetchPresc({required String uid}) async {
    final prescritions = await query(uid: uid).get();
    return prescritions.docs.map((doc) => doc.data()).toList();
  }

  //

  Future<void> delPresc({required String uid, required PrescModel model}) =>
      _firestore.doc(path(uid, model.id.toString())).delete();
}

@Riverpod(keepAlive: true)
PrescFirebase prescFirebase(PrescFirebaseRef ref) =>
    PrescFirebase(FirebaseFirestore.instance);
