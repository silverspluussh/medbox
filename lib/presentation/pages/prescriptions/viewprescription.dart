import 'dart:io';

import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/constants/fonts.dart';
import 'package:MedBox/data/repos/Dbhelpers/prescriptiondb.dart';
import 'package:MedBox/utils/extensions/shareplus.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../domain/sharedpreferences/sharedprefs.dart';
import 'addprescription.dart';

class Prescription extends StatefulWidget {
  const Prescription({Key key}) : super(key: key);

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text(
          'Prescription Gallery',
          style: TextStyle(fontSize: 12, fontFamily: 'Popb'),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: PrescriptionDB().getprescription(),
          builder: (context, image) {
            if (image.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: AppColors.primaryColor,
                ),
              );
            }
            if (!image.hasData) {
              return const Center(
                child: Text('No Prescription data available'),
              );
            }
            if (image.hasError) {
              return const Center(
                child: Text('Database has error'),
              );
            }

            return image.data.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No Prescriptions added.', style: popblack),
                        const SizedBox(height: 50),
                        Semantics(
                          button: true,
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const AddPrescription()))),
                            child: Card(
                              color: AppColors.primaryColor,
                              child: const Text(
                                'Add a Prescription',
                                style: popwhite,
                              ).px8().py8().centered(),
                            ),
                          ),
                        )
                      ],
                    ).px64(),
                  )
                : GridView.builder(
                    itemCount: image.data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 4,
                            childAspectRatio: 0.69,
                            crossAxisCount: 2),
                    itemBuilder: (con, index) {
                      return SizedBox(
                        height: size.height * 0.3,
                        width: size.width * 0.46,
                        child: Column(
                          children: [
                            Image.file(File(image.data[index].fileimagepath),
                                height: size.height * 0.26,
                                width: size.width * 0.46,
                                fit: BoxFit.fill),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(image.data[index].title.toUpperCase(),
                                    style: popblack),
                                IconButton(
                                    onPressed: () {
                                      Shareservice().shareplus(
                                          paths:
                                              image.data[index].fileimagepath,
                                          title: image.data[index].title,
                                          text:
                                              'Client name: ${SharedCli().getusername()}\nPrescription  title: ${image.data[index].title}');
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      size: 25,
                                      color: AppColors.primaryColor,
                                    )).px12()
                              ],
                            )
                          ],
                        ),
                      ).p8();
                    });
          }),
    );
  }
}
