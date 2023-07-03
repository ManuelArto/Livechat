import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../providers/location_provider.dart';

class RepositionButton extends StatelessWidget {
  
  const RepositionButton({
    super.key,
    required MapController mapController,
  }) : _mapController = mapController;

  final MapController _mapController;


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FloatingActionButton(
        onPressed: () {
            final LatLng friendLocation = LatLng(
              locationProvider.userLat,
              locationProvider.userLong,
            );
            _mapController.move(friendLocation, 13.0);
        },
        backgroundColor: theme.primaryColor,
        elevation: 2,
        child: Icon(
          Icons.location_on,
          size: 45,
          color: theme.secondaryHeaderColor,
        ),
      ),
    );
  }
}
