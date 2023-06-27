import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:livechat/constants.dart';
import 'package:provider/provider.dart';

import '../../../../models/friend.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/http_requester.dart';
import '../user_tile.dart';
import '../user_tiles.dart';

class FindUsersTab extends StatefulWidget {
  const FindUsersTab(String searchString, {super.key})
      : _searchString = searchString;

  final String _searchString;

  @override
  State<FindUsersTab> createState() => _FindUsersTabState();
}

class _FindUsersTabState extends State<FindUsersTab> {
  
  Future<List<Friend>?> _findNewFriends() async {
    final String token = Provider.of<AuthProvider>(context, listen: false).authUser!.token;

    List<Friend> newFriends = (await HttpRequester.get(
      URL_FRIENDS_SEARCH.format(widget._searchString),
      token,
    ) as List)
        .map((user) => Friend.fromJson(user))
        .toList();

    return newFriends.isNotEmpty ? newFriends : null;
  }

  @override
  Widget build(BuildContext context) {
    return widget._searchString.length < 3
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder(
            future: _findNewFriends(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return snapshot.hasData
                  ? CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 12.0),
                          sliver: UserTiles(
                            users: snapshot.data!,
                            action: UserAction.ADD,
                          ),
                        ),
                      ],
                    )
                  : const Center(child: Text("No new friends found!"));
            },
          );
  }
}
