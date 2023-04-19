import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../domain/models/vitalsmodel.dart';

class RadialBarAngle extends StatefulWidget {
  const RadialBarAngle({super.key, required this.model});
  final List<VModel> model;

  @override
  State<RadialBarAngle> createState() => _RadialBarAngleState();
}

class _RadialBarAngleState extends State<RadialBarAngle> {
  _RadialBarAngleState();
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(
          text: 'Overview Chart'.toUpperCase(),
          textStyle:
              const TextStyle(fontFamily: 'Pop', fontWeight: FontWeight.w500)),
      legend: Legend(
          height: '200',
          isVisible: true,
          iconHeight: 30,
          iconWidth: 30,
          overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,
      series: _getRadialBarSeries(
        t: double.parse('${widget.model[0].temperature}'),
        bmi: double.parse('${widget.model[0].bmi}'),
        bp: double.parse('${widget.model[0].bloodpressure}'),
        h: double.parse('${widget.model[0].height}'),
        hr: double.parse('${widget.model[0].heartrate}'),
        ox: double.parse('${widget.model[0].oxygenlevel}'),
        rr: double.parse('${widget.model[0].respiration}'),
        w: double.parse('${widget.model[0].weight}'),
      ),
    ).py32();
  }

  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarSeries(
      {required t, ox, hr, bp, rr, bmi, h, w}) {
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
            ChartSampleData(
                x: 'Height\n$h m',
                y: h,
                text: 'Height',
                pointColor: const Color.fromRGBO(63, 224, 0, 1.0)),
            ChartSampleData(
                x: 'Weight\n$w kg',
                y: w,
                text: 'Weight  ',
                pointColor: const Color.fromRGBO(226, 1, 26, 1.0)),
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
