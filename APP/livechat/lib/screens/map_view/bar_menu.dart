import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'map_view_screen.dart';
import 'menu_on_map.dart';

class BarMenu extends StatefulWidget {
  const BarMenu({
    super.key,
    required MapController mapController,
    required this.friendsOnMap,
  }) : _mapController = mapController;

  final MapController _mapController;
  final List<Friends> friendsOnMap;

  @override
  State<BarMenu> createState() => _BarMenuState();
}

class _BarMenuState extends State<BarMenu> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 110,
      right: 110,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < 6) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize: 4/6,
                  minChildSize: 0.2,
                  maxChildSize: 0.8,
                  expand: false,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return MenuOnMap(mapController: widget._mapController, scrollController: scrollController, friendsOnMap: widget.friendsOnMap);
                  },
                );
              },
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Divider(
                color: Colors.grey[400],
                thickness: 4.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
