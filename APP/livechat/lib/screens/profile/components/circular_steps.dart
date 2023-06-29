import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/settings_provider.dart';

class CircularSteps extends StatelessWidget {
  const CircularSteps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int steps = 4000;
    int goal = Provider.of<SettingsProvider>(context).settings.goalSteps;

    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: steps/goal,
              strokeWidth: 20,
              valueColor: AlwaysStoppedAnimation<Color>(
                steps < goal * 25 / 100
                    ? Colors.red
                    : steps < goal * 50 / 100
                        ? Colors.orange
                        : steps < goal * 75 / 100
                            ? Colors.blue
                            : Colors.green,
              ),
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
    );
  }
}
