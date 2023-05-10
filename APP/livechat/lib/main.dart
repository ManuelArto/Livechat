import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/providers/socket_provider.dart';
import 'package:livechat/screens/auth_screen.dart';
import 'package:livechat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, SocketProvider>(
          create: (context) => SocketProvider(),
          update: (context, auth, chatProvider) => chatProvider!..update(auth),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LiveChat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary: Colors.orangeAccent),
        ),
        home: Consumer<Auth>(
          builder: (context, auth, _) => auth.isAuth
              ? const HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : const AuthScreen(),
                ),
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AuthScreen.routeName:
              return MaterialPageRoute(builder: (context) => const AuthScreen());
            case ChatScreen.routeName:
              return MaterialPageRoute(builder: (context) => ChatScreen(settings.arguments as String),);
            case HomeScreen.routeName:
            default:
              return MaterialPageRoute(builder: (context) => const HomeScreen());
          }
        },
      ),
    );
  }
}
