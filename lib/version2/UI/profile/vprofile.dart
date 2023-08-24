// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:developer';
import 'package:MedBox/version2/firebase/profilefirebase.dart';
import 'package:MedBox/version2/models/profilemodel.dart';
import 'package:MedBox/version2/providers.dart/authprovider.dart';
import 'package:MedBox/version2/wiis/formfieldwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../constants/colors.dart';
import '../../wiis/txt.dart';

class UpdateProfile extends ConsumerStatefulWidget {
  const UpdateProfile({super.key, required this.pm});
  final List<ProfileModel> pm;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends ConsumerState<UpdateProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController bg = TextEditingController();

  TextEditingController dob = TextEditingController();
  TextEditingController allergies = TextEditingController();
  TextEditingController medconditions = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    address.dispose();
    dob.dispose();
    allergies.dispose();
    medconditions.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    name.text = FirebaseAuth.instance.currentUser!.displayName!;
    email.text = FirebaseAuth.instance.currentUser!.email!;
    widget.pm.isNotEmpty && widget.pm.first.allergies!.isNotEmpty
        ? widget.pm.first.allergies!.forEach((element) {
            allergic.add(element);
          })
        : allergic.clear();

    //
    widget.pm.isNotEmpty && widget.pm.first.healthConditions!.isNotEmpty
        ? widget.pm.first.healthConditions!.forEach((element) {
            condit.add(element);
          })
        : condit.clear();
  }

  bool svalg = false;
  bool hcon = false;

  List<String> allergic = [];
  List<String> condit = [];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider);
    final fprof = ref.watch(profileFirebaseProvider);

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: kprimary,
                        )),
                    const Spacer(),
                    Ltxt(text: AppLocalizations.of(context)!.uprofile),
                    const Spacer()
                  ],
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Row(
                  children: [
                    FormfieldX(
                      controller: name,
                      hinttext: user.currentUser!.displayName,
                      inputType: TextInputType.name,
                      readonly: true,
                      label: AppLocalizations.of(context)!.fullname,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FormfieldX(
                      controller: email,
                      hinttext: user.currentUser!.email,
                      inputType: TextInputType.name,
                      readonly: true,
                      label: AppLocalizations.of(context)!.email,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FormfieldX(
                      controller: dob,
                      hinttext:
                          widget.pm.isEmpty || widget.pm.first.dob!.isEmpty
                              ? ' d/m/y'
                              : widget.pm.first.dob,
                      inputType: TextInputType.text,
                      readonly: true,
                      suffix: IconButton(
                          onPressed: () => showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .add(const Duration(days: -36500)),
                                      lastDate: DateTime.now().add(730.days))
                                  .then((value) {
                                dob.text = value.toString().split(' ').first;
                              }),
                          icon: const Icon(Icons.calendar_view_day,
                              color: kprimary)),
                      label: AppLocalizations.of(context)!.dob,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FormfieldX(
                      controller: bg,
                      hinttext: widget.pm.isEmpty ||
                              widget.pm.first.bloodGroup!.isEmpty
                          ? 'select blood group'
                          : widget.pm.first.bloodGroup,
                      inputType: TextInputType.name,
                      readonly: true,
                      label: AppLocalizations.of(context)!.bg,
                      suffix: DropdownButton(
                          underline: const SizedBox(),
                          items: [
                            ...['A', 'B', 'AB', 'O'].map((e) =>
                                DropdownMenuItem(
                                    value: e, child: Btxt(text: e)))
                          ],
                          onChanged: (e) {
                            bg.text = e!;
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FormfieldX(
                      controller: allergies,
                      hinttext:
                          'seperate allergies with a comma (nuts,milk,etc)',
                      inputType: TextInputType.name,
                      readonly: false,
                      label: AppLocalizations.of(context)!.allergies,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            svalg = true;
                            allergic.clear();
                            allergies.text.split(',').forEach((element) {
                              allergic.add(element);
                            });
                          });
                        },
                        child: Card(
                          color: kprimary.withOpacity(0.7),
                          child: const Itxt(text: 'save allergies').centered(),
                        ),
                      ),
                    ),
                    const Spacer()
                  ],
                ),
                Visibility(
                  visible: allergic.isNotEmpty,
                  child: Row(
                    children: [
                      ...allergic.map((e) => Card(
                            color:
                                e.isNotEmpty ? Colors.teal : kBackgroundColor,
                            child: Itxt(text: e).py4().px8(),
                          ).p4())
                    ],
                  ).px4(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FormfieldX(
                      controller: medconditions,
                      hinttext: 'format :diabetes,decay,stroke,etc',
                      inputType: TextInputType.name,
                      readonly: false,
                      label: AppLocalizations.of(context)!.hconditions,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            hcon = true;
                            condit.clear();
                            medconditions.text.split(',').forEach((element) {
                              condit.add(element);
                            });
                          });
                        },
                        child: Card(
                          color: kprimary.withOpacity(0.7),
                          child: const Itxt(text: 'save conditions').centered(),
                        ),
                      ),
                    ),
                    const Spacer()
                  ],
                ),
                Visibility(
                  visible: condit.isNotEmpty,
                  child: Row(
                    children: [
                      ...condit.map((e) => Card(
                            color: e.isNotEmpty
                                ? Colors.deepPurple
                                : kBackgroundColor,
                            child: Itxt(text: e).py4().px8(),
                          ).p4())
                    ],
                  ).px4(),
                )
              ])),
              SliverToBoxAdapter(
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.green,
                            child: Container(
                              height: size.height * 0.25,
                              width: size.width * 0.75,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Save changes to profile',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Text('Do you wish to continue with action?',
                                      textAlign: TextAlign.justify,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    height: 40,
                                    width: size.width * 0.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            context.pop();

                                            if (widget.pm.isNotEmpty) {
                                              final profmodel = ProfileModel(
                                                  allergies: allergic.isEmpty
                                                      ? widget
                                                          .pm.first.allergies
                                                      : allergic,
                                                  bloodGroup: bg.text.isEmpty
                                                      ? widget
                                                          .pm.first.bloodGroup
                                                      : bg.text,
                                                  dob: dob.text.isEmpty
                                                      ? widget.pm.first.dob
                                                      : dob.text,
                                                  email: email.text,
                                                  fullname: name.text,
                                                  healthConditions: condit
                                                          .isEmpty
                                                      ? widget.pm.first
                                                          .healthConditions
                                                      : condit,
                                                  homeAddress:
                                                      address.text.isEmpty
                                                          ? widget.pm.first
                                                              .homeAddress
                                                          : address.text);

                                              try {
                                                fprof
                                                    .updateProfile(
                                                        uid: user
                                                            .currentUser!.uid,
                                                        med: profmodel)
                                                    .whenComplete(() {
                                                  allergic.clear();
                                                  bg.clear();
                                                  name.clear();
                                                  address.clear();
                                                  email.clear();
                                                  condit.clear();
                                                  dob.clear();
                                                  return VxToast.show(context,
                                                      textSize: 11,
                                                      msg:
                                                          'Profile updated successfully.',
                                                      bgColor:
                                                          const Color.fromARGB(
                                                              255, 38, 99, 40),
                                                      textColor: Colors.white,
                                                      pdHorizontal: 30,
                                                      pdVertical: 20);
                                                }).then((h) {});
                                              } catch (e) {
                                                log(e.toString());
                                              }
                                            } else {
                                              final profmodel = ProfileModel(
                                                  allergies: allergic,
                                                  bloodGroup: bg.text,
                                                  dob: dob.text,
                                                  email: email.text,
                                                  fullname: name.text,
                                                  healthConditions: condit,
                                                  homeAddress: address.text);

                                              try {
                                                fprof
                                                    .addProfile(
                                                        uid: user
                                                            .currentUser!.uid,
                                                        med: profmodel)
                                                    .whenComplete(() {
                                                  allergic.clear();
                                                  bg.clear();
                                                  name.clear();
                                                  address.clear();
                                                  email.clear();
                                                  condit.clear();
                                                  dob.clear();
                                                  return VxToast.show(context,
                                                      textSize: 11,
                                                      msg:
                                                          'Profile created successfully.',
                                                      bgColor:
                                                          const Color.fromARGB(
                                                              255, 38, 99, 40),
                                                      textColor: Colors.white,
                                                      pdHorizontal: 30,
                                                      pdVertical: 20);
                                                }).then((h) {});
                                              } catch (e) {
                                                log(e.toString());
                                              }
                                            }
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!.yes,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 15,
                                                fontFamily: 'Pop'),
                                          ),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!.no,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Pop'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Card(
                          color: kprimary,
                          child: const Itxt(text: 'Save all changes')
                              .py12()
                              .px8()
                              .centered())
                      .py32()
                      .px32(),
                ),
              )
            ],
          ).px8(),
        ),
      ),
    ));
  }
}
