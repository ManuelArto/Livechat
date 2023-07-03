import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

import '../models/auth/auth_user.dart';

class LocationProvider extends ChangeNotifier {
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  StreamSubscription<LocationData>? _listener;

  AuthUser? _authUser;
  late LocationData _locationData;

  double get userLat => _locationData.latitude!;
  double get userLong => _locationData.longitude!;

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
  void dispose() async {
    await _listener?.cancel();
    super.dispose();
  }

  Future<bool> canAccessLocationService() async {
    // Check if the location service is enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        debugPrint("SERVICEEEEEE");
        return false;
      }
    }

    // Check if the required permission is granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        debugPrint("PERMISSIONNNN");
        return false;
      }
    }

    _locationData = await _location.getLocation();
    _location.enableBackgroundMode(enable: true);
    _startListener();

    return true;
  }

  void _startListener() {
    _listener = _location.onLocationChanged.listen(
      (LocationData currentLocation) {
        _locationData = currentLocation;
        notifyListeners();
      },
    );
  }
}
