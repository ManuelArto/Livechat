import 'package:flutter/material.dart';

import '../../../models/friend.dart';
import 'friend_tiles.dart';

class FriendsRequestsTab extends StatelessWidget {
  FriendsRequestsTab({Key? key}) : super(key: key);

  final List<Friend> _requests = List.generate(
    50,
    (index) => Friend(
        username: "Username$index", imageUrl: "https://picsum.photos/$index"),
  );

  final List<Friend> _mineRequests = List.generate(
    5,
    (index) => Friend(
        username: "Username$index", imageUrl: "https://picsum.photos/$index"),
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "FRIEND REQUESTS",
                  style: TextStyle(
                    fontSize: theme.textTheme.bodyLarge!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showBottomModal(context, theme),
                  child: Row(
                    children: [
                      Text(
                        "Sended",
                        style: TextStyle(
                          fontSize: theme.textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_sharp, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FriendTiles(
            users: _requests,
            buttonText: "ACCEPT",
          ),
        ],
      ),
    );
  }

  void _showBottomModal(BuildContext context, ThemeData theme) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Sended Requests',
                style: TextStyle(
                  fontSize: theme.textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(child: FriendTiles(users: _mineRequests))
          ],
        );
      },
    );
  }
}
