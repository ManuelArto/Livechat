import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../models/friend.dart';
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
  String _searchingString = "";
  final TextEditingController _searchController = TextEditingController();
  late List<Friend> friendsFiltered;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _searchingString = _searchController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Friends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 1),
          SearchBar(
            hintText: "Find a friend",
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            textStyle: MaterialStateProperty.all(
              const TextStyle(backgroundColor: Colors.transparent),
            ),
            controller: _searchController,
            leading: const Icon(Icons.search_rounded),
            trailing: _searchController.text.isNotEmpty
                ? [
                    IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: _searchController.clear),
                  ]
                : null,
          ),
          if (_searchingString.isEmpty) ...[
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 1),
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
          ] else
            Expanded(child: FindUsersTab(_searchingString, widget.friendsOnMap, widget._mapController))
        ],
      ),
    );
  }
}

class FindUsersTab extends StatefulWidget {
  const FindUsersTab(String searchingString, this.friendsOnMap, this._mapController, {super.key})
      : _searchingString = searchingString;

  final String _searchingString;
  final List<Friends> friendsOnMap;
  final MapController _mapController;

  @override
  State<FindUsersTab> createState() => _FindUsersTabState();
}

class _FindUsersTabState extends State<FindUsersTab> {
  @override
  Widget build(BuildContext context) {
    List<Friends> friendsFiltered = widget.friendsOnMap
        .where(
          (friends) => friends.name
              .toLowerCase()
              .contains(widget._searchingString.toLowerCase()),
        )
        .toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 12.0),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: friendsFiltered.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(friendsFiltered[index].name),
                subtitle: Text('Steps: ${friendsFiltered[index].steps}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(friendsFiltered[index].img),
                ),
                onTap: () {
                  setState(() {
                    final LatLng friendLocation = LatLng(
                      friendsFiltered[index].latitude,
                      friendsFiltered[index].longitude,
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
