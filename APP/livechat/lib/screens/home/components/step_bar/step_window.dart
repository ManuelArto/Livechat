import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepWindows extends StatefulWidget {
  const StepWindows({
    super.key,
  });

  @override
  State<StepWindows> createState() => _StepWindowsState();
}

class _StepWindowsState extends State<StepWindows> {
  late List<StepsData> _chartData;

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Andamento settimanale'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Expanded(
              child: Container(
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
            ),
            const Text("Passi totali effettuati: 49000"),
            const SizedBox(height: 3),
            const Text(
                "Calorie bruciate: 150 kcal"), // passi totali * 3
            const SizedBox(height: 3),
            const Text(
                "Chilometri fatti: 29.4 km"), // passi totali * 0.6
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
    final List<StepsData> chartData = [
      StepsData(17, 2000),
      StepsData(16, 5000),
      StepsData(15, 8000),
      StepsData(14, 9000),
      StepsData(13, 12000),
      StepsData(12, 10000),
      StepsData(11, 3000),
    ];
    return chartData;
  }
}

class StepsData {
  StepsData(this.day, this.steps);
  final int day;
  final int steps;
}
