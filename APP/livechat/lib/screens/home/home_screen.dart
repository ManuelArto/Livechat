import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

import 'ranking_screen.dart';
import 'components/card_home.dart';
import 'components/heading_home.dart';
import 'components/previews/previews_page_view.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey navigatorKey;

  const HomeScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
      
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

    return const Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadingHome(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CardHome(
                      imgPath: "home/chat_icon.png",
                      nameCard: "Chat",
                      description:
                          "Start private conversations with your friends",
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHome(
                      imgPath: "home/map_icon.png",
                      nameCard: "Map",
                      description:
                          "Explore the real-time locations of your friends",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CardHome(
                      imgPath: "home/friends_icon.png",
                      nameCard: "Friends",
                      description:
                          "Connect and build new friendships with people. Send and view friend requests",
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHome(
                      imgPath: "home/profile_icon.png",
                      nameCard: "Profile",
                      description:
                          "View your personal information and customize your theme settings and more",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: PreviewsPageView(),
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
