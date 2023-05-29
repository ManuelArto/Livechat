import 'package:flutter/material.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: const Center(child: Text("MapView Screen")),
    );
  }
}