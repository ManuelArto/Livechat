import 'package:livechat/models/friend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/friends_provider.dart';


class ProfileIcon extends StatelessWidget {
  const ProfileIcon({required this.user, Key? key}) : super(key: key);

  final Friend user;

  @override
  Widget build(BuildContext context) {
    FriendsProvider usersProvider = Provider.of<FriendsProvider>(context);
    return Hero(
      tag: user.username,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(right: 10.0),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            CircleAvatar(
              backgroundColor: usersProvider.userIsOnline(user.username)
                  ? Colors.greenAccent[700]
                  : Colors.red,
              radius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
