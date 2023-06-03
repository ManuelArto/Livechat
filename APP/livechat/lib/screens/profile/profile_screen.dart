import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfileScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: Colors.green,
        child: const Center(child: Text("Profile Screen")),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}