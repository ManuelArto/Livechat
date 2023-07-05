import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/auth/auth_user.dart';

class StepsProvider extends ChangeNotifier {
  late Function _errorCallBack;
  late Stream<StepCount> _stepCountStream;

  AuthUser? _authUser;
  String _steps = '?';

  get steps => int.tryParse(_steps) ?? 0;

  // Called everytime AuthProvider changes
  void update(AuthUser? authUser) {
    if (authUser == null) {
      _authUser = null;
    } else {
      _authUser = authUser;
    }
  }

  void onStepCount(StepCount event) {
    debugPrint('$event');
    _steps = event.steps.toString();
    notifyListeners();
  }

  void onStepCountError(error) {
    debugPrint('Step Count not available');
    _errorCallBack();
  }

  Future<bool> initPedometer(Function errorCallBack) async {
    _errorCallBack = errorCallBack;

    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);

      return true;
    }

    return false;
  }
}
