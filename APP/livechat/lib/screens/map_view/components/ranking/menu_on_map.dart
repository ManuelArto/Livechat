import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../map_view_screen.dart';

class MenuOnMap extends StatefulWidget {
  const MenuOnMap({
      super.key,
      required this.friendsOnMap,
      required this.scrollController,
      required MapController mapController, 
    }) : _mapController = mapController;

  final MapController _mapController;
  final List<Friends> friendsOnMap;
  final ScrollController scrollController;
  @override
  State<MenuOnMap> createState() => _MenuOnMapState();
}

class _MenuOnMapState extends State<MenuOnMap> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Friends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(thickness: 1),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(thickness: 1),
            controller: widget.scrollController,
            itemCount: widget.friendsOnMap.length,
            itemBuilder: (context, index) {
              Friends friend = widget.friendsOnMap[index];
              return ListTile(
                title: Text(friend.name),
                subtitle: Text('Steps: ${friend.steps}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(friend.img),
                ),
                onTap: () {
                  setState(() {
                    final LatLng friendLocation = LatLng(
                      friend.latitude,
                      friend.longitude,
                    );
                    widget._mapController.move(friendLocation, 13.0);
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
