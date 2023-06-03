import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

class FriendsScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const FriendsScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: Colors.yellow,
        child: const Center(child: Text("Friends Screen")),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}