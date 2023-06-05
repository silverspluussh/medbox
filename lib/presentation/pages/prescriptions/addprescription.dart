// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/data/repos/Dbhelpers/prescriptiondb.dart';
import 'package:MedBox/domain/models/prescribemodel.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/formfieldwidget.dart';

class AddPrescription extends StatefulWidget {
  const AddPrescription({super.key});

  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  final formkey = GlobalKey<FormState>();

  List<CameraDescription>? cameras;
  CameraController? _controller;

  XFile? file;

  User? user;

  TextEditingController titlecontroller = TextEditingController();

  String filepath = '';

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      _controller = CameraController(cameras![0], ResolutionPreset.max);

      _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {}
  }

  @override
  void initState() {
    PrescriptionDB().initDatabase();
    loadCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
              key: formkey,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: kprimary,
                        )),
                    centerTitle: true,
                    title: _labeltext(
                        color: Colors.black,
                        label: 'Upload your prescriptions'),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    SizedBox(
                            height: size.height * 0.35,
                            width: size.width * 0.8,
                            child: _controller == null
                                ? const Center(child: Text("Loading Camera..."))
                                : !_controller!.value.isInitialized
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CameraPreview(_controller!))
                        .centered(),
                    const SizedBox(height: 10),
                    IconButton(
                            onPressed: () async {
                              try {
                                if (_controller != null) {
                                  if (_controller!.value.isInitialized) {
                                    file = await _controller!.takePicture();
                                    filepath = file!.path;

                                    await GallerySaver.saveImage(file!.path,
                                            albumName: 'Prescription')
                                        .then((value) {
                                      setState(() {});
                                    });
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: const Icon(Icons.camera_alt_outlined,
                                size: 40, color: kprimary))
                        .centered(),
                    SizedBox(
                            height: size.height * 0.35,
                            width: size.width * 0.5,
                            child: file != null
                                ? Image.file(File(file!.path))
                                : Image.asset(
                                    'assets/images/medical-pr.jpg',
                                    fit: BoxFit.fill,
                                  ))
                        .centered(),
                    const SizedBox(height: 30),
                    FormfieldX(
                      readonly: false,
                      validator: (e) {
                        return e.toString().isEmpty
                            ? 'field cannot be empty'
                            : null;
                      },
                      label: 'Add title of prescription',
                      hinttext: 'eg. prescription from Dr. Lewis',
                      controller: titlecontroller,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: size.width * 0.6,
                      child: TextButton(
                        onPressed: () {
                          PrescModel prescribe = PrescModel(
                            id: Random().nextInt(100),
                            datetime: DateTime.now()
                                .toString()
                                .toString()
                                .split(' ')
                                .first,
                            fileimagepath: filepath,
                            title: titlecontroller.text,
                          );

                          PrescriptionDB()
                              .addpres(ppModel: prescribe)
                              .then((value) {
                            setState(() {
                              context.pop(context);
                            });
                          });
                        },
                        child: _labeltext(
                                label: 'Add Prescription', color: Colors.white)
                            .centered(),
                      ),
                    ).px12()
                  ])),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  )
                ],
              ))
          .animate()
          .slideX(duration: 300.milliseconds, delay: 100.milliseconds),
    );
  }

  Text _labeltext({String? label, color}) {
    return Text(label!, style: Theme.of(context).textTheme.titleSmall);
  }
}
