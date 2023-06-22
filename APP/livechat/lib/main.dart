import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livechat/database/isar_service.dart';
import 'package:provider/provider.dart';

import 'package:livechat/screens/app_screen.dart';
import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/providers/socket_provider.dart';
import 'package:livechat/screens/auth/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  IsarService.instance;

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
        ChangeNotifierProxyProvider<AuthProvider,SocketProvider>(
          create: (_) => SocketProvider(),
          update: (_, auth, socketProvider) => socketProvider!..update(auth),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Livechat',
        // TODO: carica tema da utente se loggato
        theme: FlexThemeData.light(scheme: FlexScheme.brandBlue),
        //darkTheme: FlexThemeData.dark(scheme: FlexScheme.brandBlue),
        themeMode: ThemeMode.system,
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
      ),
    );
  }
}
