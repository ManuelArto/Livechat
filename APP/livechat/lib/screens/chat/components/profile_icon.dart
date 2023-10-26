import 'package:flutter/material.dart';

import '../../../models/user.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({required this.user, Key? key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: user.isOnline ? Colors.greenAccent[700] : Colors.red,
              radius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
