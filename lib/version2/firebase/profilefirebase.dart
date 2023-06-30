import 'package:MedBox/version2/models/profilemodel.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profilefirebase.g.dart';

class ProfileFirebase {
  const ProfileFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  static String pPath(String uid, String medID) => 'users/$uid/profile/$medID';
  static String pPaths(String uid) => 'users/$uid/profile';

  Query<ProfileModel> queryMeds({required String uid}) {
    return _firestore.collection(pPaths(uid)).withConverter(
          fromFirestore: (snapshot, _) =>
              ProfileModel.fromJson(snapshot.data()!, tid: snapshot.id),
          toFirestore: (job, _) => job.toJson(),
        );
  }

  Future<void> addProfile({required String uid, required ProfileModel med}) =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('profile')
          .doc('${uid}001')
          .set(med.toJson());

  Future<void> updateProfile(
          {required String uid, required ProfileModel med}) =>
      _firestore.doc(pPath(uid, med.id!)).update(med.toJson());

  Future<void> delProfile({required String uid, required ProfileModel pp}) =>
      _firestore.doc(pPath(uid, pp.id!)).delete();

  Stream<List<ProfileModel>> strProfs({required String uid}) {
    return queryMeds(uid: uid)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}

@Riverpod(keepAlive: true)
ProfileFirebase profileFirebase(ProfileFirebaseRef ref) =>
    ProfileFirebase(FirebaseFirestore.instance);

@riverpod
Stream<List<ProfileModel>> streamProfs(StreamProfsRef ref) {
  final repo = ref.watch(profileFirebaseProvider);
  final user = ref.watch(authRepositoryProvider);
  return repo.strProfs(uid: user.currentUser!.uid);
}
