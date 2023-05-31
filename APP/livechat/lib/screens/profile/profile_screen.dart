import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: Colors.green,
        child: const Center(child: Text("Profile Screen")),
      ),
    );
  }
}