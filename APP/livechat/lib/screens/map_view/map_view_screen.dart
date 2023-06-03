import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';

class MapViewScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MapViewScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: const TopBar(),
      body: Container(
        color: Colors.purple,
        child: const Center(child: Text("MapView Screen")),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}