
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../models/auth/auth_user.dart';
import '../../../providers/auth_provider.dart';
import '../map_view_screen.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required MapController mapController,
    required this.userLat,
    required this.userLong,
    required this.steps,
    required this.friendsOnMap,
  }) : _mapController = mapController;

  final MapController _mapController;
  final double userLat;
  final double userLong;
  final int steps;
  final List<Friends> friendsOnMap;

  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthProvider>(context, listen: false).authUser!;

    return FlutterMap(
      options: MapOptions(
        center: LatLng(44.494887, 11.3426163),
        zoom: 8,
        minZoom: 3,
        maxZoom: 18,
      ),
      mapController: _mapController,
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 50.0,
              height: 50.0,
              point: LatLng(userLat, userLong), // qui andranno authUser.lat e authUser.long
              builder: (ctx) => Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: '${authUser.username}\n$steps steps', // qui andrà authUser.steps
                preferBelow: false,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      maxRadius: 10.0,
                      backgroundImage: NetworkImage(authUser.imageUrl),
                    ),
                  ),
                ),
              ),
            ),
            for (var friend in friendsOnMap)
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(friend.latitude, friend.longitude),
                builder: (ctx) => Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: '${friend.name}\n${friend.steps} steps',
                  preferBelow: false,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    maxRadius: 10.0,
                    backgroundImage: NetworkImage(friend.img),
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }
}
