import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../data/repos/Dbhelpers/vitalsdb.dart';
import '../../../domain/models/vitalsmodel.dart';

class VitalsTable extends StatefulWidget {
  const VitalsTable({super.key});

  @override
  State<VitalsTable> createState() => _VitalsTableState();
}

class _VitalsTableState extends State<VitalsTable> {
  List<VModel> getvitals = [];

  @override
  void initState() {
    VitalsDB().getvitals().then((value) {
      getvitals = value;
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Client Vitals Readings over 7 days'.toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Popb',
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              pinned: true,
              floating: true,
              elevation: 0,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      dividerThickness: 5,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.primaryColor.withOpacity(0.6),
                      ),
                      border: TableBorder.all(color: Colors.black, width: 2),
                      columns: [
                        ...labels.map((e) => DataColumn(
                                label: Text(
                              e.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontFamily: 'Pop'),
                            )))
                      ],
                      rows: [
                        ...getvitals.map((e) => DataRow(cells: [
                              DataCell(
                                Text(e.datetime!),
                              ),
                              DataCell(
                                Text(e.temperature!),
                              ),
                              DataCell(
                                Text(e.bloodpressure!),
                              ),
                              DataCell(
                                Text(e.heartrate!),
                              ),
                              DataCell(
                                Text(e.respiration!),
                              ),
                              DataCell(
                                Text(e.oxygenlevel!),
                              ),
                              DataCell(
                                Text(e.bmi!),
                              ),
                            ]))
                      ]).py20().px12(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<String> labels = [
  'Day',
  'Temperature (deg)',
  'Blood Pressure (mmHg)',
  'Heart Rate (bpm)',
  'Respiration Rate (bpm)',
  'Oxygen Levels (%)',
  'BMI (kg/m2)'
];
