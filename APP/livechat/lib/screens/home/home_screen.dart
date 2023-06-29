import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import '../../models/auth/auth_user.dart';
import '../../providers/auth_provider.dart';
import 'ranking_screen.dart';
import 'components/card_home.dart';
import 'components/heading_home.dart';
import 'components/page_view_home.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey navigatorKey;

  const HomeScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
      
  Route<dynamic>? _buildRoute(settings) {
    switch (settings.name) {
      case RankingScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const RankingScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => _buildOnScreen(context),
        );
    }
  }

 Scaffold _buildOnScreen(BuildContext context) {
    super.build(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    AuthUser authUser = authProvider.authUser!;

    return Scaffold(
      appBar: const TopBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadingHome(authUser: authUser),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CardHome(
                      imgURL:
                          "https://cdn.pixabay.com/photo/2017/06/10/07/21/chat-2389223_960_720.png",
                      nameCard: "Chat",
                      description:
                          "Start private conversations or join group chats with your friends",
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHome(
                      imgURL:
                          "https://img.lovepik.com/free-png/20210919/lovepik-map-location-sign-number-png-image_400315655_wh1200.png",
                      nameCard: "Map",
                      description:
                          "Explore the real-time locations of your friends on a map when they are online",
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CardHome(
                      imgURL:
                          "https://media.istockphoto.com/id/1064128676/it/vettoriale/icona-del-segno-del-gruppo-di-persone-simbolo-di-condivisione-bottone-navigazione-nel.jpg?s=1024x1024&w=is&k=20&c=IRexgR3l1fo0NmP8mZV9sdNDHbw-hHyPmi3AHJ4gOm4=",
                      nameCard: "Friends",
                      description:
                          "Connect and build new friendships with people. Send and view friend requests",
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHome(
                      imgURL:
                          "https://static.vecteezy.com/system/resources/previews/022/876/363/non_2x/social-media-user-3d-cartoon-illustration-speech-bubble-with-internet-icon-png.png",
                      nameCard: "Profile",
                      description:
                          "Customize your profile. View and update your personal information and edit the theme",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: PageViewHome(authUser: authUser),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Navigator(
      key: widget.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: _buildRoute,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
