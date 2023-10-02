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
  final ProfileModel pm;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends ConsumerState<UpdateProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();

  TextEditingController dob = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    address.dispose();
    dob.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    name.text = FirebaseAuth.instance.currentUser!.displayName!;
    email.text = FirebaseAuth.instance.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider);
    final fprof = ref.watch(profileFirebaseProvider);

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 45,
          centerTitle: true,
          title: Ltxt(text: AppLocalizations.of(context)!.uprofile),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          30.heightBox,
          const Ltxt(text: 'Username:').px12(),
          10.heightBox,
          Customfield(
            controller: name,
            hinttext: user.currentUser!.displayName,
            inputType: TextInputType.name,
            readonly: true,
          ),
          const SizedBox(height: 15),
          const Ltxt(text: 'Email:').px12(),
          10.heightBox,
          Customfield(
            controller: email,
            hinttext: user.currentUser!.email,
            inputType: TextInputType.name,
            readonly: true,
          ),
          const SizedBox(height: 15),
          const Ltxt(text: 'Date of Birth:').px12(),
          10.heightBox,
          Customfield(
            controller: dob,
            hinttext: widget.pm.dob!.isEmpty ? ' d/m/y' : widget.pm.dob,
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
                icon: const Icon(Icons.calendar_month, color: kprimary)),
          ),
          15.heightBox,
          const Ltxt(text: 'Home Address:').px12(),
          10.heightBox,
          Customfield(
            controller: address,
            hinttext: widget.pm.homeAddress!.isEmpty
                ? ' home address'
                : widget.pm.homeAddress,
            inputType: TextInputType.name,
            readonly: false,
          ),
          15.heightBox
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
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            Text('Do you wish to continue with action?',
                                textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      context.pop();

                                      if (widget.pm.pEmail != null) {
                                        final profmodel = ProfileModel(
                                            dob: dob.text.isEmpty
                                                ? widget.pm.dob
                                                : dob.text,
                                            pEmail: email.text,
                                            fullname: name.text,
                                            homeAddress: address.text.isEmpty
                                                ? widget.pm.homeAddress
                                                : address.text);

                                        try {
                                          fprof
                                              .updateProfile(med: profmodel)
                                              .whenComplete(() {
                                            name.clear();
                                            address.clear();
                                            email.clear();
                                            dob.clear();
                                            return VxToast.show(context,
                                                textSize: 11,
                                                msg:
                                                    'Profile updated successfully.',
                                                bgColor: const Color.fromARGB(
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
                                            dob: dob.text,
                                            pEmail: email.text,
                                            fullname: name.text,
                                            homeAddress: address.text);

                                        try {
                                          fprof
                                              .addProfile(med: profmodel)
                                              .whenComplete(() {
                                            name.clear();
                                            address.clear();
                                            email.clear();
                                            dob.clear();
                                            return VxToast.show(context,
                                                textSize: 11,
                                                msg:
                                                    'Profile created successfully.',
                                                bgColor: const Color.fromARGB(
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
    ));
  }
}
