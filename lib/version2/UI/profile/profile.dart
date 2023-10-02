import 'package:MedBox/version2/UI/profile/vprofile.dart';
import 'package:MedBox/version2/firebase/profilefirebase.dart';
import 'package:MedBox/version2/models/profilemodel.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../wiis/shimmer.dart';
import '../../wiis/txt.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        title: Ltxt(text: AppLocalizations.of(context)!.mprof.toUpperCase()),
      ),
      body: StreamBuilder<ProfileModel>(
          stream: ref.watch(profileFirebaseProvider).getSingleProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ProfileModel p = snapshot.data!;
              return CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    20.heightBox,
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(user!.photoURL!),
                    ).centered(),
                    15.heightBox,
                    Profilecard(
                            label: AppLocalizations.of(context)!.fullname,
                            data: user.displayName!)
                        .centered(),
                    10.heightBox,
                    Profilecard(
                            label: AppLocalizations.of(context)!.email,
                            data: user.email!)
                        .centered(),
                    10.heightBox,
                    Profilecard(
                            label: AppLocalizations.of(context)!.addy,
                            data: p.homeAddress!.isEmpty
                                ? 'not set'
                                : p.homeAddress!)
                        .centered(),
                    10.heightBox,
                    Profilecard(
                            label: AppLocalizations.of(context)!.dob,
                            data: p.dob!.isEmpty ? 'not set' : p.dob!)
                        .centered(),
                    const SizedBox(height: 20),
                  ])),
                  SliverToBoxAdapter(
                      child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => UpdateProfile(
                                            pm: p,
                                          ))),
                              child: Itxt(
                                  text:
                                      AppLocalizations.of(context)?.uprofile ??
                                          'Add profile'))
                          .py12()
                          .px16())
                ],
              ).px12();
            } else if (!snapshot.hasData) {
              return VStack(
                [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  ).centered(),
                  15.heightBox,
                  Profilecard(
                      label: AppLocalizations.of(context)!.fullname,
                      data: user.displayName!),
                  15.heightBox,
                  Profilecard(
                      label: AppLocalizations.of(context)!.email,
                      data: user.email!)
                ],
                alignment: MainAxisAlignment.start,
                crossAlignment: CrossAxisAlignment.center,
              );
            }
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (con, index) =>
                    const ShimmerWidget.rectangular(height: 50)).centered();
          }).animate().slideX(duration: 300.ms),
    );
  }
}

class Profilecard extends StatelessWidget {
  const Profilecard({
    super.key,
    required this.label,
    required this.data,
  });

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return VStack([
      Ttxt(text: label),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Btxt(text: data).centered(),
      )
    ]);
  }
}
