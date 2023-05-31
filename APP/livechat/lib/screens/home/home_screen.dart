import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: Colors.red,
        child: const Center(child: Text("Home Screen")),
      ),
    );
  }
}
