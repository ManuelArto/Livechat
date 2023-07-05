import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../providers/location_provider.dart';
import 'map_markers.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required MapController mapController,
  }) : _mapController = mapController;

  final MapController _mapController;

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);

    return FlutterMap(
      options: MapOptions(
        center: LatLng(locationProvider.userLat, locationProvider.userLong),
        zoom: 8,
        minZoom: 3,
        maxZoom: 18,
      ),
      mapController: _mapController,
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        const MapMarkers()
      ],
    );
  }
}
