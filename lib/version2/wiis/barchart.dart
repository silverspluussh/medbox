import 'package:MedBox/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vitalsmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BarChartSample2 extends ConsumerStatefulWidget {
  const BarChartSample2(this.vitals, {super.key});
  final Color leftBarColor = Colors.yellow;
  final Color rightBarColor = Colors.red;
  final Color avgColor = kprimary;
  final List<VModel> vitals;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends ConsumerState<BarChartSample2> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(
        0,
        double.parse(widget.vitals.first.temp.toString()),
        double.parse(widget.vitals.last.temp.toString()));
    final barGroup2 = makeGroupData(
        1,
        double.parse(widget.vitals.first.hr.toString()),
        double.parse(widget.vitals.last.hr.toString()));
    final barGroup3 = makeGroupData(
      2,
      double.parse(widget.vitals.first.bp.toString().split('/').first),
      double.parse(widget.vitals.last.bp.toString().split('/').first),
    );
    final barGroup4 = makeGroupData(
        3,
        double.parse(widget.vitals.first.bmi.toString()),
        double.parse(widget.vitals.last.bmi.toString()));
    final barGroup5 = makeGroupData(
        4,
        double.parse(widget.vitals.first.hr.toString()),
        double.parse(widget.vitals.last.hr.toString()));

    final items = [barGroup1, barGroup2, barGroup3, barGroup4, barGroup5];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/icons/Statistics.png',
                  width: 30,
                  height: 40,
                  color: kprimary,
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.overview,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pop'),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 200,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                  toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 35,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 0,
                        interval: 50,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 243, 247, 253),
      fontWeight: FontWeight.w500,
      fontSize: 11,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 50) {
      text = '50';
    } else if (value == 100) {
      text = '100';
    } else if (value == 150) {
      text = '150';
    } else if (value == 200) {
      text = '200';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Temp', 'HR', 'BP', 'BMI', 'BR'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color.fromARGB(255, 245, 245, 245),
        fontWeight: FontWeight.w500,
        fontSize: 11,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
