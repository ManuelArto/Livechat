import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:livechat/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../models/friend.dart';
import '../../../providers/users_provider.dart';

class MapFriendsList extends StatefulWidget {
  const MapFriendsList({
    super.key,
    required this.mapController,
    required this.panelController,
  });

  
  final MapController mapController;
  final PanelController panelController;

  @override
  State<MapFriendsList> createState() => _MapFriendsListState();
}

class _MapFriendsListState extends State<MapFriendsList> {
  String _searchingString = "";
  final TextEditingController _searchController = TextEditingController();

  late UsersProvider _usersProvider;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _searchingString = _searchController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    _usersProvider = Provider.of<UsersProvider>(context);

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
          CustomSearchBar(
            text: "Find a friends",
            searchController: _searchController,
          ),
          Expanded(
            child: _buildUsersTile(),
          )
        ],
      ),
    );
  }

  Widget _buildUsersTile() {
    List<Friend> friendsFiltered = _usersProvider.friends
        .where(
          (friends) => friends.username
              .toLowerCase()
              .contains(_searchingString.toLowerCase()),
        )
        .toList();

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: friendsFiltered.length,
      itemBuilder: (context, index) {
        Friend friend = friendsFiltered[index];
        return ListTile(
          title: Text(friend.username),
          subtitle: Text('Steps: ${friend.steps}'),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(friend.imageUrl),
          ),
          onTap: () {
              final LatLng friendLocation = LatLng(friend.lat, friend.long);
              widget.mapController.move(friendLocation, 13.0);
              widget.panelController.close();
          },
        );
      },
    );
  }
}
