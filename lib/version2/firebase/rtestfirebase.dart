import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/rapidtestmodel.dart';
part 'rtestfirebase.g.dart';

class RtestFirebse {
  const RtestFirebse(this._firestore);
  final FirebaseFirestore _firestore;

  Stream<List<RapidtestModel>> streamTests() => queryTests()
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());

  Query<RapidtestModel> queryTests() => _firestore
      .collection("rapidtests")
      .where("patientID", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .withConverter(
        fromFirestore: (snapshot, _) =>
            RapidtestModel.fromJson(snapshot.data()!, tid: snapshot.id),
        toFirestore: (job, _) => {},
      );
}

@Riverpod(keepAlive: true)
RtestFirebse rtestFirebase(RtestFirebaseRef ref) =>
    RtestFirebse(FirebaseFirestore.instance);

@riverpod
Stream<List<RapidtestModel>> streamTests(StreamTestsRef ref) {
  final repo = ref.watch(rtestFirebaseProvider);
  return repo.streamTests();
}
