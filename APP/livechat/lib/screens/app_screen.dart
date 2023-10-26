import 'package:flutter/material.dart';
import 'package:livechat/providers/chat_provider.dart';
import 'package:livechat/providers/location_provider.dart';
import 'package:livechat/providers/navbar_notifier.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:livechat/providers/steps_provider.dart';
import 'package:livechat/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/socket_provider.dart';
import '../widgets/bottom_bar.dart';
import 'chat/chats_screen.dart';
import 'friends/friends_screen.dart';
import 'home/home_screen.dart';
import 'map_view/map_view_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final List<GlobalKey<NavigatorState>> keys = List.generate(5, (index) => GlobalKey());
  late final List<Widget> _tabScreens;

  @override
  void initState() {
    super.initState();
    _tabScreens = <Widget>[
      HomeScreen(navigatorKey: keys[0]),
      ChatsScreen(navigatorKey: keys[1]),
      MapViewScreen(navigatorKey: keys[2]),
      FriendsScreen(navigatorKey: keys[3]),
      ProfileScreen(navigatorKey: keys[4]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final SocketProvider socketProvider = Provider.of<SocketProvider>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavbarNotifier>(
          create: (_) => NavbarNotifier(keys),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UsersProvider>(
          create: (_) {
              UsersProvider usersProvider = UsersProvider();
              socketProvider.usersProvider = usersProvider;
              return usersProvider;
            },
          update:(context, auth, friends) => friends!..update(auth.authUser),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          create: (_) {
              ChatProvider chatProvider = ChatProvider();
              socketProvider.chatProvider = chatProvider;
              return chatProvider;
            },
          update:(context, auth, chat) => chat!..update(auth.authUser),
        ),
        ChangeNotifierProxyProvider<AuthProvider, LocationProvider>(
          create: (_) => LocationProvider(),
          update:(context, auth, location) => location!..update(auth.authUser),
        ),
        ChangeNotifierProxyProvider<AuthProvider, StepsProvider>(
          create: (_) => StepsProvider(),
          update:(context, auth, steps) => steps!..update(auth.authUser),
        ),
      ],
      builder: (context, child) {
        NavbarNotifier navbarNotifier = context.watch<NavbarNotifier>();

        return WillPopScope(
        onWillPop: () async => await navbarNotifier.onBackButtonPressed(),
        child: Scaffold(
          bottomNavigationBar: const BottomBar(),
          body: IndexedStack(
            index: navbarNotifier.tabIndex,
            children: _tabScreens,
          ),
        ),
      );
      }
    );
  }
}
