import 'package:flutter/material.dart';

class MapViewScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MapViewScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Scaffold();
  }

  @override
  bool get wantKeepAlive => true;
}
