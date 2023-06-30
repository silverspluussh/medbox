import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/rapidtestmodel.dart';
import '../models/usermodel.dart';

part 'rtestfirebase.g.dart';

class RtestFirebse {
  const RtestFirebse(this._firestore);
  final FirebaseFirestore _firestore;

  static String rsPath(UserID uid) => 'users/$uid/rapidtest';

  Stream<List<RapidtestModel>> streamTests({required String uid}) =>
      queryTests(uid: uid)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());

  Query<RapidtestModel> queryTests({required String uid}) => _firestore
      .collection(rsPath(uid))
      .withConverter(
        fromFirestore: (snapshot, _) =>
            RapidtestModel.fromJson(snapshot.data()!, tid: snapshot.id),
        toFirestore: (job, _) => job.toJson(),
      )
      .orderBy('id');
}

@Riverpod(keepAlive: true)
RtestFirebse rtestFirebase(RtestFirebaseRef ref) =>
    RtestFirebse(FirebaseFirestore.instance);

@riverpod
Stream<List<RapidtestModel>> streamTests(StreamTestsRef ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  final repo = ref.watch(rtestFirebaseProvider);
  return repo.streamTests(uid: user!.uid);
}
