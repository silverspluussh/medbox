import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../domain/models/vitalsmodel.dart';

class RadialBarAngle extends StatefulWidget {
  final List<VModel> model;

  const RadialBarAngle({super.key, required this.model});

  @override
  State<RadialBarAngle> createState() => _RadialBarAngleState();
}

class _RadialBarAngleState extends State<RadialBarAngle> {
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(height: '0', isVisible: false),
      title: ChartTitle(
          text: 'Overview Chart'.toUpperCase(),
          textStyle:
              const TextStyle(fontFamily: 'Pop', fontWeight: FontWeight.w500)),
      tooltipBehavior: _tooltipBehavior,
      series: _getRadialBarSeries(
        t: double.parse(widget.model[0].temperature!),
        bp: double.parse(widget.model[0].bloodpressure!),
        hr: double.parse(widget.model[0].heartrate!),
        ox: double.parse(widget.model[0].oxygenlevel!),
        rr: double.parse(widget.model[0].respiration!),
      ),
    );
  }

  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarSeries(
      {t, ox, hr, bp, rr, bmi}) {
    final List<RadialBarSeries<ChartSampleData, String>> list =
        <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
          animationDuration: 1,
          maximumValue: 200,
          radius: '100%',
          strokeWidth: 40,
          gap: '%2',
          innerRadius: '30%',
          dataSource: <ChartSampleData>[
            ChartSampleData(
                x: 'Temperature\n$t deg.celsius',
                y: t,
                text: 'Temperature',
                pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
            ChartSampleData(
                x: 'Oxygen Level\n$ox %',
                y: ox,
                text: 'Oxygen Levels',
                pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
            ChartSampleData(
                x: 'Heart Rate\n$hr bpm',
                y: hr,
                text: 'Heart Rate',
                pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
            ChartSampleData(
                x: 'Blood pressure\n$bp mmHg',
                y: bp,
                text: 'Blood pressure',
                pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
            ChartSampleData(
                x: 'Respiration rate\n$rr bpm',
                y: rr,
                text: 'Respiration',
                pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
            ChartSampleData(
                x: 'Body Mass Index\n$bmi kgm2',
                y: bmi,
                text: 'BMI',
                pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
          ],
          cornerStyle: CornerStyle.bothCurve,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
    return list;
  }
}

class ChartSampleData {
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  final dynamic x;

  final num? y;

  final dynamic xValue;

  final num? yValue;

  final num? secondSeriesYValue;

  final num? thirdSeriesYValue;

  final Color? pointColor;

  final num? size;

  final String? text;

  final num? open;

  final num? close;

  final num? low;

  final num? high;

  final num? volume;
}
