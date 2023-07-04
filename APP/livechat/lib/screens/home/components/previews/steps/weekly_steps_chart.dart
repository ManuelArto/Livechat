import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeeklyStepsChart extends StatefulWidget {
  const WeeklyStepsChart({
    super.key,
  });

  @override 
  State<WeeklyStepsChart> createState() => _WeeklyStepsChartState();
}

class _WeeklyStepsChartState extends State<WeeklyStepsChart> {
  late List<StepsData> _chartData;

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int totalStepsOfWeek = _chartData.fold(0, (int sum, StepsData data) => sum + data.steps);
    final double totalkCal = totalStepsOfWeek * 3;
    final double totalKm = totalStepsOfWeek * 0.6;

    return AlertDialog(
      title: const Text('Weekly Trend'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Expanded(
              child: SfCartesianChart(
                series: <ChartSeries>[
                  BarSeries<StepsData, int>(
                    dataSource: _chartData,
                    xValueMapper: (StepsData data, _) =>
                        data.day,
                    yValueMapper: (StepsData data, _) =>
                        data.steps,
                    dataLabelSettings:
                        const DataLabelSettings(
                      isVisible: true,
                    ),
                  ),
                ],
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  edgeLabelPlacement:
                      EdgeLabelPlacement.shift,
                  title: AxisTitle(text: 'Steps'),
                ),
              ),
            ),
            Text("Total steps: $totalStepsOfWeek"),
            const SizedBox(height: 3),
            Text("Burned calories: $totalkCal kcal"), // passi totali * 3
            const SizedBox(height: 3),
            Text("Kilometers: $totalKm km"), // passi totali * 0.6
          ],
        ),
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

  List<StepsData> getChartData() {
    final List<StepsData> chartData = [];
    final DateTime today = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final DateTime date = today.subtract(Duration(days: i));
      final int day = date.day;
      final int steps = 1500; // bisogna prelevare i passi giornalieri
      
      final StepsData data = StepsData(day, steps);
      chartData.add(data);
    }
    
    return chartData;
  }
}

class StepsData {
  StepsData(this.day, this.steps);
  final int day;
  final int steps;
}
