import 'dart:developer';

import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/data/repos/Dbhelpers/prescriptiondb.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Prescription extends StatefulWidget {
  const Prescription({super.key});

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: const Text('Prescription Panel'),
      ),
      body: FutureBuilder(
          future: PrescriptionDB.getprescribe(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: AppColors.primaryColor,
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No Prescription data available'),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Database has error'),
              );
            }

            return snapshot.data!.isEmpty
                ? Center(
                    child: Text(snapshot.data![0]['datetime']),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                          height: 60,
                          width: size.width,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(width: 4, color: Colors.black12)),
                          child: HStack(
                              alignment: MainAxisAlignment.spaceBetween,
                              [
                                Checkbox(
                                    onChanged: (e) {},
                                    value: true,
                                    activeColor: AppColors.primaryColor),
                                Text(
                                  snapshot.data![index]['title']!,
                                  style: const TextStyle(
                                      fontFamily: 'Pop', fontSize: 13),
                                ),
                                InkWell(
                                    onTap: () {},
                                    child: SizedBox(
                                      height: 60,
                                      //width: 150,
                                      child: Card(
                                        color: AppColors.primaryColor,
                                        child: const Text(
                                          'Send to',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Pop',
                                              fontSize: 12),
                                        ).centered().px12().py8(),
                                      ),
                                    ))
                              ])).py4();
                    });
            ;
          }),
    );
  }
}
