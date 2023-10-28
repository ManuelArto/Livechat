

import 'package:flutter/material.dart';
import 'package:livechat/models/chat/chat.dart';

import '../group_info_screen.dart';

class GroupIcon extends StatelessWidget {
  const GroupIcon({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          GroupInfoScreen.routeName,
          arguments: chat,
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 10.0),
          child: const CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage('assets/images/group_icon.png'),
          ),
        ),
      );
  }
}