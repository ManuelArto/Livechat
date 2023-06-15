import 'package:flutter/material.dart';

class CircularSteps extends StatelessWidget {
  const CircularSteps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int steps = 6;

    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: steps / 10,
              strokeWidth: 20,
              valueColor: AlwaysStoppedAnimation<Color>(
                steps < 2.5
                    ? Colors.red
                    : steps < 5
                        ? Colors.orange
                        : steps < 7.5
                            ? Colors.blue
                            : Colors.green,
              ),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
        Center(
          child: Text(
            "${steps * 1000}/10000",
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
