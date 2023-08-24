import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../models/vitalsmodel.dart';

class LineChartx extends StatelessWidget {
  const LineChartx(
      {super.key, required this.isShowingMainData, required this.vitals});
  final List<VModel> vitals;
  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 11,
        maxY: 200,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 11,
        maxY: 200,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(reservedSize: 0, showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(reservedSize: 0, showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
      ];

  SideTitles leftTitles() => const SideTitles(
        showTitles: false,
        interval: 1,
        reservedSize: 0,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('Temp', style: style);
        break;
      case 4:
        text = const Text('Heart rate', style: style);
        break;
      case 6:
        text = const Text('BP', style: style);
        break;
      case 8:
        text = const Text('Breathe rate', style: style);
        break;
      case 10:
        text = const Text('BMI', style: style);
        break;

      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 18,
        interval: 2,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.red,
        barWidth: 2,
        showingIndicators: [2, 3],
        isStrokeCapRound: true,
        aboveBarData: BarAreaData(show: true, color: kprimary.withOpacity(0.2)),
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: true),
        spots: [
          const FlSpot(0, 0),
          FlSpot(2, double.parse(vitals.last.temp.toString())),
          FlSpot(4, double.parse(vitals.last.hr.toString())),
          FlSpot(6, double.parse(vitals.last.bp.toString().split('/').first)),
          FlSpot(8, double.parse(vitals.last.br.toString())),
          FlSpot(10, double.parse(vitals.last.bmi.toString())),
          const FlSpot(11, 0),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        //  curveSmoothness: 0,
        color: kred.withOpacity(0.9),
        barWidth: 2,
        aboveBarData: BarAreaData(show: true, color: kprimary.withOpacity(0.2)),

        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Colors.purple.withOpacity(0.2),
        ),
        spots: [
          const FlSpot(0, 0),
          FlSpot(2, double.parse(vitals.first.temp.toString())),
          FlSpot(4, double.parse(vitals.first.hr.toString())),
          FlSpot(6, double.parse(vitals.first.bp.toString().split('/').first)),
          FlSpot(8, double.parse(vitals.first.br.toString())),
          FlSpot(10, double.parse(vitals.first.bmi.toString())),
          const FlSpot(11, 0),
        ],
      );
}

class VitalsLineChart extends StatefulWidget {
  const VitalsLineChart({super.key, required this.vitals});
  final List<VModel> vitals;

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<VitalsLineChart> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Stack(
        children: <Widget>[
          LineChartx(
            vitals: widget.vitals,
            isShowingMainData: isShowingMainData,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color:
                      Colors.purple.withOpacity(isShowingMainData ? 1.0 : 0.5),
                ),
                onPressed: () {
                  setState(() {
                    isShowingMainData = !isShowingMainData;
                  });
                },
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
