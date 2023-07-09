import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:format/format.dart';
import 'package:geolocator/geolocator.dart';
import 'package:livechat/services/http_requester.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../models/auth/auth_user.dart';

class LocationProvider extends ChangeNotifier {
  bool _serviceEnabled = false;
  PermissionStatus? _permission;
  StreamSubscription<Position>? _positionListener;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  AuthUser? _authUser;
  late Position _position;
  late Function _errorCallBack;

  double get userLat => _position.latitude;
  double get userLong => _position.longitude;

  void setPermission(PermissionStatus permission) => _permission = permission;

  // Called everytime AuthProvider changes
  void update(AuthUser? authUser) {
    if (authUser == null) {
      _serviceEnabled = false;
      _authUser = null;
    } else {
      _authUser = authUser;
    }
  }

  @override
  void dispose() {
    _positionListener?.cancel();
    super.dispose();
  }

  Future<Position> getCurrentPosition(Function errorCallBack) async {
    _errorCallBack = errorCallBack;

    // Test if location services are enabled
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    _permission = _permission ?? await Permission.location.status;
    if (_permission == PermissionStatus.denied) {
      return Future.error('Location permissions are denied');
    }
    if (_permission == PermissionStatus.permanentlyDenied) {
      return Future.error('Location permissions are permanently denied');
    }

    _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .onError((error, stackTrace) => Future.error(error.toString()));
    _updateLocation();
    _startListener();

    return _position;
  }

  void _startListener() {
    _positionListener = Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) {
        _position = position;
        debugPrint("Update Location ${position.latitude} ${position.longitude}");

        _updateLocation();
        notifyListeners();
      },
    );
    _positionListener?.onError((_) => _errorCallBack());
  }

  void _updateLocation() {
    HttpRequester.post(
      {},
      URL_UPDATE_LOCATION.format(_position.latitude, _position.longitude),
      token: _authUser?.token,
    );
  }
}
