import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: Colors.purple,
        child: const Center(child: Text("MapView Screen")),
      ),
    );
  }
}