import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:format/format.dart';
import 'package:geolocator/geolocator.dart';
import 'package:livechat/services/http_requester.dart';

import '../constants.dart';
import '../models/auth/auth_user.dart';

class LocationProvider extends ChangeNotifier {
  bool _serviceEnabled = false;
  LocationPermission? _permission;
  StreamSubscription<Position>? _positionListener;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  AuthUser? _authUser;
  late Position _position;

  double get userLat => _position.latitude;
  double get userLong => _position.longitude;

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

  Future<Position> getCurrentPosition() async {
    // Test if location services are enabled
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied ||
          _permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are denied');
      }
    }

    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _startListener();

    return _position;
  }

  void _startListener() {
    _positionListener = Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position? position) {
        _position = position ?? _position;
        debugPrint(
            "Update Location ${position?.latitude} ${position?.longitude}");

        HttpRequester.post(
          {},
          URL_UPDATE_LOCATION.format(_position.latitude, _position.longitude),
          token: _authUser?.token,
        );
        notifyListeners();
      },
    );
  }
}
