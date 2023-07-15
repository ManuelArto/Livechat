import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:livechat/constants.dart';
import 'package:livechat/models/steps.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/isar_service.dart';
import '../models/auth/auth_user.dart';
import '../services/http_requester.dart';

class StepsProvider extends ChangeNotifier {
  late Function _errorCallBack;
  late Stream<StepCount> _stepCountStream;

  AuthUser? _authUser;
  Steps? _steps;
  PermissionStatus? _permission;

  int get steps => _steps?.steps ?? 0;

  get kcal => (steps / 1000 * 3).toStringAsFixed(2);
  get km => (steps / 1000 * 0.6).toStringAsFixed(2);

  void setPermission(PermissionStatus permission) => _permission = permission;

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
    _steps?.updateSteps(event, _steps?.timeStamp != null ? isSameDayAccess(event.timeStamp, _steps!.timeStamp!) : false);

    _updateSteps();
    notifyListeners();
    IsarService.instance.insertOrUpdate<Steps>(_steps!);
  }

  void onStepCountError(error) {
    debugPrint('Step Count not available');
    _errorCallBack();
  }

  Future<void> initPedometer(Function errorCallBack) async {
    _errorCallBack = errorCallBack;

    await _loadStepsFromMemory();

    _permission = _permission ?? await Permission.activityRecognition.request();
    if (_permission == PermissionStatus.denied) {
      return Future.error('Pedometer permissions are denied');
    }
    if (_permission == PermissionStatus.permanentlyDenied) {
      return Future.error('Pedometer permissions are permanently denied');
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  Future<void> _loadStepsFromMemory() async {
    _steps = await IsarService.instance.getSingle<Steps>(_authUser!.isarId);

    if (_steps == null || !isSameDayAccess(_steps!.timeStamp!, DateTime.now())) {
      if (_steps != null) {
        await IsarService.instance.delete<Steps>(_steps!.id);
      }
      _steps = Steps(userId: _authUser!.isarId);
    }
  }

  bool isSameDayAccess(DateTime date, DateTime compare) {
    return date.day == compare.day;
  }

  void _updateSteps() {
    HttpRequester.post(
      {},
      URL_UPDATE_STEPS.format(steps),
      token: _authUser?.token,
    );
  }

}
