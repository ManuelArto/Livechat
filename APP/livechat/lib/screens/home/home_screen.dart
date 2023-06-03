import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey navigatorKey;

  const HomeScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: Colors.red,
        child: const Center(child: Text("Home Screen")),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
