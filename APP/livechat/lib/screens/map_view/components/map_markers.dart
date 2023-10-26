import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livechat/providers/steps_provider.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/auth/auth_user.dart';
import '../../../models/friend.dart';
import '../../../models/user.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/users_provider.dart';
import '../../../providers/location_provider.dart';

class MapMarkers extends StatefulWidget {
  const MapMarkers({super.key});

  @override
  State<MapMarkers> createState() => _MapMarkersState();
}

class _MapMarkersState extends State<MapMarkers> {
  late LocationProvider locationProvider;
  late StepsProvider stepsProvider;
  late UsersProvider usersProvider;
  late AuthUser authUser;
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    authUser = Provider.of<AuthProvider>(context, listen: false).authUser!;
    usersProvider = Provider.of<UsersProvider>(context);
    locationProvider = Provider.of<LocationProvider>(context);
    stepsProvider = Provider.of<StepsProvider>(context);

    theme = Theme.of(context);

    return MarkerLayer(
      markers: [
        _buildMarker(
          size: 50.0,
          user: authUser,
          location: LatLng(locationProvider.userLat, locationProvider.userLong),
          isMe: true,
        ),
        for (var friend in usersProvider.friends)
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
    final steps = isMe ? stepsProvider.steps : (user as Friend).steps;

    return Marker(
      width: size,
      height: size,
      point: location,
      builder: (ctx) => Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        message: '${user.username}\n$steps steps',
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
                : usersProvider.getUser(user.username).isOnline
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
