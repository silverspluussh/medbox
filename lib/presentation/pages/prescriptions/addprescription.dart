import 'dart:io';
import 'dart:math';
import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/data/repos/Dbhelpers/prescriptiondb.dart';
import 'package:MedBox/domain/models/prescribemodel.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:velocity_x/velocity_x.dart';

class AddPrescription extends StatefulWidget {
  const AddPrescription({super.key});

  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  List<CameraDescription>? cameras;
  CameraController? _controller;

  XFile? file;

  User? user;

  TextEditingController titlecontroller = TextEditingController();

  late String filepath = '';

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
    } else {
      //  log("NO  camera found");
    }
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
        backgroundColor: AppColors.scaffoldColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: AppColors.primaryColor,
                  )),
              centerTitle: true,
              title: _labeltext(
                  color: Colors.black, label: 'Upload your prescriptions'),
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
                        } catch (e) {}
                      },
                      icon: const Icon(Icons.camera_alt_outlined,
                          size: 40, color: AppColors.primaryColor))
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
              SizedBox(
                height: 50,
                width: size.width * 0.7,
                child: TextFormField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 7),
                      label: _labeltext(
                          label: 'Add title of prescription',
                          color: Colors.black),
                      hintText: 'eg. prescription from Dr. Lewis',
                      labelStyle: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Popb',
                          color: Colors.black),
                      hintStyle: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Pop',
                          color: Colors.black26),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              width: 1.3, color: AppColors.primaryColor))),
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                button: true,
                child: InkWell(
                  onTap: () {
                    PrescModel prescribe = PrescModel(
                        id: Random().nextInt(100),
                        datetime: DateTime.now()
                            .toString()
                            .toString()
                            .split(' ')
                            .first,
                        fileimagepath: filepath,
                        title: titlecontroller.text);

                    PrescriptionDB().addpres(ppModel: prescribe).then((value) {
                      setState(() {
                        context.pop(context);
                      });
                    });
                  },
                  child: SizedBox(
                      height: 50,
                      width: 200,
                      child: Card(
                        color: AppColors.primaryColor,
                        child: _labeltext(
                                label: 'Add Prescription', color: Colors.white)
                            .centered(),
                      )),
                ),
              )
            ])),
          ],
        ));
  }
}

Text _labeltext({required String label, required color}) {
  return Text(
    label,
    style: TextStyle(
        fontFamily: 'Popb',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color),
  );
}
