import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Center(child: Text("Home Screen")),
    );
  }
}
