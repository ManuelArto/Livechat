import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/auth/auth_user.dart';
import '../../../models/user.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/friends_provider.dart';
import '../../../providers/location_provider.dart';

class MapMarkers extends StatefulWidget {
  const MapMarkers({super.key});

  @override
  State<MapMarkers> createState() => _MapMarkersState();
}

class _MapMarkersState extends State<MapMarkers> {
  late LocationProvider locationProvider;
  late FriendsProvider friendsProvider;
  late AuthUser authUser;
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    authUser = Provider.of<AuthProvider>(context, listen: false).authUser!;
    friendsProvider = Provider.of<FriendsProvider>(context);
    locationProvider = Provider.of<LocationProvider>(context);

    theme = Theme.of(context);

    return MarkerLayer(
      markers: [
        _buildMarker(
          size: 50.0,
          user: authUser,
          location: LatLng(locationProvider.userLat, locationProvider.userLong),
          isMe: true,
        ),
        for (var friend in friendsProvider.friends)
          _buildMarker(
            size: 40.0,
            user: friend,
            location: LatLng(friend.lat, friend.long),
            isMe: false,
          )
      ],
    );
  }

  Marker _buildMarker({
    required double size,
    required User user,
    required LatLng location,
    required bool isMe,
  }) {
    return Marker(
      width: size,
      height: size,
      point: location,
      builder: (ctx) => Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        message: '${user.username}\n10000 steps', // TODO: qui andrà user.steps
        preferBelow: false,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isMe ? theme.primaryColor : theme.primaryColor.lighten(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isMe
                ? theme.primaryColor
                : friendsProvider.getFriend(user.username).isOnline
                    ? Colors.green
                    : Colors.red,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              maxRadius: 10.0,
              backgroundImage: NetworkImage(user.imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
