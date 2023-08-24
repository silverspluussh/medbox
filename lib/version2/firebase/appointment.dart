import 'package:MedBox/version2/models/appointments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers.dart/authprovider.dart';

part 'appointment.g.dart';

class AppointmentFirebase {
  const AppointmentFirebase(this._firestore);
  final FirebaseFirestore _firestore;

  static String appointmentPath(String uid, APID aid) =>
      'users/$uid/appointments/$aid';
  static String apspath(String uid) => 'users/$uid/appointments';

  Future<void> addAppointment({required String uid, required ApModel med}) =>
      _firestore.collection(apspath(uid)).add(med.toJson());

  Future<void> updateAp({required String uid, required ApModel ap}) =>
      _firestore.doc(appointmentPath(uid, ap.aid!)).update(ap.toJson());

  Future<void> deleteAp({required String uid, required APID aid}) =>
      _firestore.doc(appointmentPath(uid, aid)).delete();

  Stream<ApModel> streamAp({required String uid, required ApModel med}) =>
      _firestore
          .doc(appointmentPath(uid, med.aid!))
          .withConverter(
              fromFirestore: (snap, _) =>
                  ApModel.fromJson(snap.data()!, aid: snap.id),
              toFirestore: (snap, _) => med.toJson())
          .snapshots()
          .map((event) => event.data()!);

  Stream<List<ApModel>> streamAps({required String uid}) => queryAps(uid: uid)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());

  Query<ApModel> queryAps({required String uid}) => _firestore
      .collection(apspath(uid))
      .withConverter(
        fromFirestore: (snapshot, _) =>
            ApModel.fromJson(snapshot.data()!, aid: snapshot.id),
        toFirestore: (job, _) => job.toJson(),
      )
      .orderBy('date');

  Future<List<ApModel>> fetchAps({required String uid}) async {
    final apps = await queryAps(uid: uid).get();
    return apps.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
AppointmentFirebase appointmentFirebase(AppointmentFirebaseRef ref) =>
    AppointmentFirebase(FirebaseFirestore.instance);

@riverpod
Stream<List<ApModel>> streamAppointments(StreamAppointmentsRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  final meds = ref.watch(appointmentFirebaseProvider);
  return meds.streamAps(uid: user!.uid);
}
