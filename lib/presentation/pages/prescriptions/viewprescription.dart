import 'package:MedBox/constants/colors.dart';
import 'package:MedBox/data/repos/Dbhelpers/prescriptiondb.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'addprescription.dart';

class Prescription extends StatefulWidget {
  const Prescription({super.key});

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
          'Prescription Panel',
          style: TextStyle(fontSize: 13, fontFamily: 'Popb'),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: PrescriptionDB().getprescribe(),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No Prescriptions added.',
                          style:
                              TextStyle(fontFamily: 'Pop', color: Colors.black),
                        ),
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
                                style: TextStyle(
                                    fontFamily: 'Pop', color: Colors.white),
                              ).px8().py8().centered(),
                            ),
                          ),
                        )
                      ],
                    ).px64(),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                          height: 80,
                          width: size.width,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(10),
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
