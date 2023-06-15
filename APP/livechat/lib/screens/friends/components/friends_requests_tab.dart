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

    return Column(
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
                  fontWeight: theme.textTheme.bodyLarge!.fontWeight,
                ),
              ),
              GestureDetector(
                onTap: () => _showBottomModal(context),
                child: Row(
                  children: [
                    Text(
                      "Sended",
                      style: TextStyle(
                        fontSize: theme.textTheme.bodySmall!.fontSize,
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
        Expanded(
          child: FriendTiles(
            users: _requests,
            isRequest: true,
          ),
        ),
      ],
    );
  }

  void _showBottomModal(BuildContext context) {
  }
}