import 'package:MedBox/version2/UI/profile/vprofile.dart';
import 'package:MedBox/version2/firebase/profilefirebase.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:MedBox/version2/wiis/async_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../constants/colors.dart';
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
    final profile = ref.watch(streamProfsProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: kprimary,
            )),
        centerTitle: true,
        title: Ltxt(text: AppLocalizations.of(context)!.mprof),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: AsyncValueWidget(
            loading: ListView.builder(
                itemCount: 10,
                itemBuilder: (con, index) =>
                    const ShimmerWidget.rectangular(height: 60)).centered(),
            value: profile,
            data: (p) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  ).centered()),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Profilecard(
                            label: AppLocalizations.of(context)!.fullname,
                            data: user.displayName!)
                        .centered(),
                    Profilecard(
                            label: AppLocalizations.of(context)!.email,
                            data: user.email!)
                        .centered(),
                    Profilecard(
                            label: AppLocalizations.of(context)!.addy,
                            data: p.isEmpty || p.first.homeAddress!.isEmpty
                                ? 'not set'
                                : p.first.homeAddress!)
                        .centered(),
                    Profilecard(
                            label: AppLocalizations.of(context)!.dob,
                            data: p.isEmpty || p.first.dob!.isEmpty
                                ? 'not set'
                                : p.first.dob!)
                        .centered(),
                    const Divider(),
                    HStack(alignment: MainAxisAlignment.start, [
                      Ttxt(text: AppLocalizations.of(context)!.bg),
                      const SizedBox(width: 40),
                      Card(
                        child: Btxt(
                                text: p.isEmpty || p.first.bloodGroup!.isEmpty
                                    ? 'not set'.toUpperCase()
                                    : p.first.bloodGroup!)
                            .px16()
                            .py12(),
                      )
                    ]).centered(),
                    const SizedBox(height: 15),
                    Ltxt(text: AppLocalizations.of(context)!.allergies)
                        .centered(),
                    const SizedBox(height: 10),
                  ])),
                  SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                              childAspectRatio: 4,
                              crossAxisCount: 2),
                      itemCount: p.isNotEmpty && p.first.allergies!.isNotEmpty
                          ? p.first.allergies!.length
                          : 1,
                      itemBuilder: ((context, index) => Card(
                            color: Colors.teal,
                            child: Text(
                              p.isNotEmpty
                                  ? p.first.allergies![index]
                                  : 'allergies not set'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: kwhite),
                            ).centered().p4(),
                          ))),
                  SliverToBoxAdapter(
                    child: Ltxt(text: AppLocalizations.of(context)!.hconditions)
                        .centered()
                        .py8(),
                  ),
                  SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                              childAspectRatio: 4,
                              crossAxisCount: 2),
                      itemCount:
                          p.isNotEmpty && p.first.healthConditions!.isNotEmpty
                              ? p.first.healthConditions!.length
                              : 1,
                      itemBuilder: ((context, index) => Card(
                            color: Colors.deepPurple,
                            child: Text(
                              p.isEmpty || p.first.healthConditions!.isEmpty
                                  ? 'Not set'.toUpperCase()
                                  : p.first.healthConditions![index],
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: kwhite),
                            ).py4().centered(),
                          ))),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 30),
                  ),
                  SliverToBoxAdapter(
                    child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UpdateProfile(
                                          pm: p,
                                        ))),
                            child: Itxt(
                                text: p.isNotEmpty
                                    ? AppLocalizations.of(context)!.uprofile
                                    : 'Add profile'))
                        .py12()
                        .px16(),
                  )
                ],
              ).px12();
            }),
      )),
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
        width: size.width * 0.75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Btxt(text: data).centered(),
      )
    ]);
  }
}
