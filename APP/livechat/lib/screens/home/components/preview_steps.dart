import 'package:flutter/material.dart';
import 'package:livechat/screens/home/components/step_bar/step_window.dart';

import '../../profile/components/circular_steps.dart';

class PreviewSteps extends StatelessWidget {
  const PreviewSteps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text('Today Steps',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          const Expanded(
            child: Center(
              child: CircularSteps(),
            ),
          ),
          Column(
            children: [
              const Text("Burned calories: 18 kcal"), // passi totali * 3
              const SizedBox(height: 5),
              const Text("Kilometers: 3.6 km"), // passi totali * 0.6
              const Divider(thickness: 1),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const StepWindows();
                    },
                  );
                },
                child: const Text('View more details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

