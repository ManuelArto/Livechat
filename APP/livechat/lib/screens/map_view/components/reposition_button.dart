import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RepositionButton extends StatefulWidget {
   const RepositionButton({
    super.key,
    required MapController mapController, 
    required this.userLat,
    required this.userLong,
  }) : _mapController = mapController;

  final MapController _mapController;
  final double userLat;
  final double userLong;

  @override
  State<RepositionButton> createState() => _RepositionButtonState();
}

class _RepositionButtonState extends State<RepositionButton> {
  @override
  Widget build(BuildContext context) {
     ThemeData theme = Theme.of(context);
    return Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    final LatLng friendLocation = LatLng(
                      widget.userLat,
                      widget.userLong,
                    );
                    widget._mapController.move(friendLocation, 13.0);
                  });
                },
                backgroundColor: theme.primaryColor,
                elevation: 2,
                child: Icon(Icons.location_on,
                    size: 45, color: theme.secondaryHeaderColor),
              ),
            ),
          );
  }
}
