import 'package:flutter/material.dart';
import 'package:livechat/providers/steps_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/settings_provider.dart';
import 'weekly_steps_chart.dart';

class CircularSteps extends StatefulWidget {
  const CircularSteps({super.key});

  @override
  State<CircularSteps> createState() => _CircularStepsState();
}

class _CircularStepsState extends State<CircularSteps> {
  @override
  Widget build(BuildContext context) {
    int steps = Provider.of<StepsProvider>(context).steps;
    int goal = Provider.of<SettingsProvider>(context).settings.goalSteps;

    Color progressColor = _getProgressColor(steps, goal);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Today Steps',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const Divider(thickness: 1),
        Expanded(
          child: Center(
            child: Stack(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: steps / goal,
                      strokeWidth: 20,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "$steps/$goal",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Text("Burned calories: ${steps * 3} kcal"),
            const SizedBox(height: 5),
            Text("Kilometers: ${(steps / 1000 * 0.6).toStringAsFixed(2)} km"),
            const Divider(thickness: 1),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WeeklyStepsChart(),
                );
              },
              child: const Text('View more details'),
            ),
          ],
        ),
      ],
    );
  }

  MaterialColor _getProgressColor(int steps, int goal) {
    double progressPercentage = steps / goal * 100;

    if (progressPercentage < 25) {
      return Colors.red;
    } else if (progressPercentage < 50) {
      return Colors.orange;
    } else if (progressPercentage < 75) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}
