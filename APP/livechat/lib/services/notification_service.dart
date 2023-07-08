import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  // SINGLETON
  static NotificationService? _instance;
  static NotificationService get instance {
    _instance ??= NotificationService();
    return _instance!;
  }

  NotificationService();

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  final StreamController<NotificationResponse> didReceiveLocalNotificationStream = StreamController<NotificationResponse>.broadcast();

  Future<void> initNotification() async {
    await Permission.notification.request();

    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('logo_nobg');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async => didReceiveLocalNotificationStream.add(notificationResponse)
    );
  }

  NotificationDetails notificationDetails(String? groupKey, String? imagePath) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          '1.0',
          'chatChannel',
          channelDescription: groupKey,
          setAsGroupSummary: true,
          importance: Importance.high,
          priority: Priority.max,
          groupKey: groupKey,
          enableVibration: true,
          styleInformation: imagePath != null
              ? BigPictureStyleInformation(
                  FilePathAndroidBitmap(imagePath),
                  hideExpandedLargeIcon: false,
                )
              : null,
        ),
        iOS: const DarwinNotificationDetails());
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    String? groupKey,
    String? imagePath,
  }) async {
    if (await Permission.notification.request().isGranted) {
      notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails(groupKey, imagePath),
        payload: title,
      );
    }
  }

  void clearAllNotification() {
    notificationsPlugin.cancelAll();
  }

  // * not working
  Future<void> _showGroupedNotification(String? groupKey) async {
    List<ActiveNotification>? activeNotifications = await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.getActiveNotifications();

    activeNotifications?.removeWhere((note) => note.groupKey != groupKey);
      
    if (activeNotifications == null || activeNotifications.isEmpty) {
      // List<String> lines = activeNotifications.map((e) => e.title.toString()).toList();
      InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
          ["aaa"],
          contentTitle: groupKey);
      AndroidNotificationDetails groupNotificationDetails =
          AndroidNotificationDetails(
              "1.0", "chatChannel",
              styleInformation: inboxStyleInformation,
              setAsGroupSummary: true,
              groupKey: groupKey,
          );

      NotificationDetails groupNotificationDetailsPlatformSpefics = NotificationDetails(android: groupNotificationDetails);
      await notificationsPlugin.show(0, '', '', groupNotificationDetailsPlatformSpefics);
    }
  }

}
