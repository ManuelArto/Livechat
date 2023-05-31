import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: Colors.yellow,
        child: const Center(child: Text("Friends Screen")),
      ),
    );
  }
}