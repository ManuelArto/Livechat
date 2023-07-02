import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart'; 
import '../../../providers/settings_provider.dart';

class CircularSteps extends StatefulWidget {
  const CircularSteps({
    super.key,
  });

  @override
  State<CircularSteps> createState() => _CircularStepsState();
}

class _CircularStepsState extends State<CircularSteps> {
   late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    debugPrint(event.toString());
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint(event.toString());
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    debugPrint(_status);
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _steps = event.x.toString();
      });
    });

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    int steps = int.tryParse(_steps) ?? 0;
    int goal = Provider.of<SettingsProvider>(context).settings.goalSteps;

    Color progressColor;

    if (steps < goal * 25 / 100) {
      progressColor = Colors.red;
    } else if (steps < goal * 50 / 100) {
      progressColor = Colors.orange;
    } else if (steps < goal * 75 / 100) {
      progressColor = Colors.blue;
    } else {
      progressColor = Colors.green;
    }

    return Stack(
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
    );
  }
}
