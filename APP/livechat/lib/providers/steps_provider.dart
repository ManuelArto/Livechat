import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:livechat/constants.dart';
import 'package:livechat/models/steps.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../database/isar_service.dart';
import '../models/auth/auth_user.dart';
import '../services/http_requester.dart';

class StepsProvider extends ChangeNotifier {
  late Function _errorCallBack;
  late Stream<StepCount> _stepCountStream;

  AuthUser? _authUser;
  late Steps _steps;

  int get steps => _steps.steps ?? 0;

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
    _steps.updateSteps(event);

    _updateSteps();
    notifyListeners();
    IsarService.instance.insertOrUpdate<Steps>(_steps);
  }

  void onStepCountError(error) {
    debugPrint('Step Count not available');
    _errorCallBack();
  }

  Future<bool> initPedometer(Function errorCallBack) async {
    _errorCallBack = errorCallBack;

    await _loadStepsFromMemory();

    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);

      return true;
    }

    return false;
  }

  Future<void> _loadStepsFromMemory() async {
    Steps? steps = await IsarService.instance.getSingle<Steps>(_authUser!.isarId);

    if (steps != null && isSameDayAccess(steps.timeStamp!)) {
      _steps = steps;
    } else {
      _steps = Steps(userId: _authUser!.isarId);
    }
  }

  bool isSameDayAccess(DateTime date) {
    return date.day == DateTime.now().day;
  }

  void _updateSteps() {
    HttpRequester.post(
      {},
      URL_UPDATE_STEPS.format(steps),
      token: _authUser?.token,
    );
  }

}
