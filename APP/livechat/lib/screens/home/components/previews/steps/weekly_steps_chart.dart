import 'package:flutter/material.dart';
import 'package:livechat/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../constants.dart';
import '../../../../../models/chart_steps_data.dart';
import '../../../../../services/http_requester.dart';

class WeeklyStepsChart extends StatefulWidget {
  const WeeklyStepsChart({
    super.key,
  });

  @override
  State<WeeklyStepsChart> createState() => _WeeklyStepsChartState();
}

class _WeeklyStepsChartState extends State<WeeklyStepsChart> {
  late List<ChartStepsData> _chartData;

  Future<void> getWeeklyChartData() async {
    String token = Provider.of<AuthProvider>(context).authUser!.token;

    _chartData = (await HttpRequester.get(
      URL_WEEKLY_STEPS,
      token,
    ) as List)
        .map((user) => ChartStepsData.fromJson(user))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      title: const Text('Weekly Trend'),
      content: FutureBuilder(
        future: getWeeklyChartData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if ((snapshot.hasError && snapshot.error is String)) {
            return Center(child: Text(snapshot.error as String));
          }

          final int totalStepsOfWeek = _chartData.fold(0, (int sum, ChartStepsData data) => sum + data.steps);
          final String totalkCal = (totalStepsOfWeek / 1000 * 3).toStringAsFixed(2);
          final String totalKm = (totalStepsOfWeek / 1000 * 0.6).toStringAsFixed(2);
          return SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.6,
            child: Column(
              children: [
                Expanded(
                  child: SfCartesianChart(
                    series: <ChartSeries>[
                      BarSeries<ChartStepsData, int>(
                        dataSource: _chartData,
                        xValueMapper: (ChartStepsData data, _) => data.day,
                        yValueMapper: (ChartStepsData data, _) => data.steps,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      title: AxisTitle(text: 'Steps'),
                    ),
                  ),
                ),
                Text("Total steps: $totalStepsOfWeek"),
                const SizedBox(height: 3),
                Text("Burned calories: $totalkCal kcal"),
                const SizedBox(height: 3),
                Text("Kilometers: $totalKm km"),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Chiudi'),
        ),
      ],
    );
  }
}
