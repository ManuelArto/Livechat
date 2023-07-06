import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:livechat/database/isar_service.dart';
import 'package:livechat/providers/settings_provider.dart';
import 'package:livechat/services/notification_service.dart';
import 'package:provider/provider.dart';

import 'package:livechat/screens/app_screen.dart';
import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/providers/socket_provider.dart';
import 'package:livechat/screens/auth/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  IsarService.instance;
  NotificationService.instance.initNotification();
  ForegroundService().start();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SocketProvider>(
          create: (_) => SocketProvider(),
          update: (_, auth, socketProvider) => socketProvider!..update(auth),
        ),
      ],
      builder: (context, child) => FutureBuilder(
        future: context.read<SettingsProvider>().loadSettings(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : const AppLoginWrapper();
        },
      ),
    );
  }
}

class AppLoginWrapper extends StatelessWidget {
  const AppLoginWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Livechat',
      theme: context.watch<SettingsProvider>().settings.theme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) => auth.isAuth
            ? const AppScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : const AuthScreen(),
              ),
      ),
    );
  }
}
