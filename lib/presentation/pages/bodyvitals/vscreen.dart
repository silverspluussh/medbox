import 'package:MedBox/domain/models/vitalsmodel.dart';
import 'package:flutter/material.dart';

class VitalsMain extends StatelessWidget {
  const VitalsMain({super.key, required this.vitals});

  final List<VModel> vitals;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      childAspectRatio: 2.2,
      mainAxisSpacing: 15,
      children: [
        VitalBox(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardtext(
                  text: 'Blood Pressure', size: 12.0, color: Colors.black),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardtext(
                      text: vitals.isNotEmpty ? vitals[0].bloodpressure : '0.0',
                      color: Colors.black,
                      size: 15.0),
                  const SizedBox(width: 5),
                  _cardtext(text: 'mmHg', color: Colors.black12, size: 11.0),
                ],
              ),
            ],
          ),
        ),
        VitalBox(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardtext(
                  text: 'Body temperature', size: 12.0, color: Colors.black),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardtext(
                      text: vitals.isNotEmpty ? vitals[0].temperature : '25',
                      color: Colors.black,
                      size: 15.0),
                  const SizedBox(width: 5),
                  _cardtext(
                      text: 'deg-celsius', color: Colors.black12, size: 11.0),
                ],
              ),
            ],
          ),
        ),
        VitalBox(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardtext(text: 'Heart Rate', size: 12.0, color: Colors.white),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardtext(
                      text: vitals.isNotEmpty ? vitals[0].heartrate : '0.0',
                      color: Colors.white,
                      size: 15.0),
                  const SizedBox(width: 5),
                  _cardtext(text: 'bpm', color: Colors.white, size: 11.0),
                ],
              ),
            ],
          ),
        ),
        VitalBox(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardtext(text: 'Oxygen level', size: 12.0, color: Colors.black),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardtext(
                      text: vitals.isNotEmpty ? vitals[0].oxygenlevel : '0.0',
                      color: Colors.black,
                      size: 15.0),
                  const SizedBox(width: 5),
                  _cardtext(text: '%', color: Colors.black12, size: 11.0),
                ],
              ),
            ],
          ),
        ),
        VitalBox(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardtext(text: 'Weight', size: 12.0, color: Colors.black),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardtext(
                      text: vitals.isNotEmpty ? vitals[0].weight : '0.0',
                      color: Colors.black,
                      size: 15.0),
                  const SizedBox(width: 5),
                  _cardtext(text: 'kg', color: Colors.black12, size: 11.0),
                ],
              ),
            ],
          ),
        ),
        VitalBox(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardtext(
                  text: 'Respiration rate', size: 12.0, color: Colors.black),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardtext(
                      text: vitals.isNotEmpty ? vitals[0].respiration : '0.0',
                      color: Colors.black,
                      size: 15.0),
                  const SizedBox(width: 5),
                  _cardtext(text: 'bpm', color: Colors.black12, size: 11.0),
                ],
              ),
            ],
          ),
        ),
        VitalBox(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardtext(
                  text: 'Body Mass Index', size: 12.0, color: Colors.black),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardtext(
                      text: vitals.isNotEmpty ? vitals[0].bmi : '0.0',
                      color: Colors.black,
                      size: 15.0),
                  const SizedBox(width: 5),
                  _cardtext(text: 'kg/m2', color: Colors.black12, size: 11.0),
                ],
              ),
            ],
          ),
        ),
        VitalBox(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cardtext(text: 'Height', size: 12.0, color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardtext(
                      text: vitals.isNotEmpty ? vitals[0].height : '0.0',
                      color: Colors.black,
                      size: 15.0),
                  const SizedBox(width: 5),
                  _cardtext(text: 'm', color: Colors.black12, size: 11.0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Text _cardtext({required text, required color, required size}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: size, fontWeight: FontWeight.w500, color: Colors.black),
  );
}

class VitalBox extends StatelessWidget {
  const VitalBox({
    super.key,
    required this.widget,
  });

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: widget);
  }
}
