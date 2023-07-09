import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> checkAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.activityRecognition,
    ].request();
  }

  static Future<void> checkSinglePermission(Permission permission, Function setStatus) async {
    PermissionStatus status = await permission.request();
    setStatus(status);
  }
}
