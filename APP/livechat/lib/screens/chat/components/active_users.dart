import 'package:livechat/providers/chat_provider.dart';
import 'package:livechat/screens/chat/components/profile_icon.dart';
import 'package:livechat/screens/chat/single_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/users_provider.dart';

class ActiveUsers extends StatelessWidget {
  final Size screenSize;

  const ActiveUsers(this.screenSize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);
    final activeUsers = usersProvider.onlineUsers;
    
    return Container(
      margin: const EdgeInsets.only(left: 30.0, top: 5),
      height: screenSize.height * 0.12,
      alignment: Alignment.centerLeft,
      child: activeUsers.isEmpty
          ? Text(
              "No active users",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: activeUsers.length,
              itemBuilder: (context, index) {
                final user = activeUsers[index];
                return GestureDetector(
                  onTap: () {
                    chatProvider.readChat(user.username);
                    Navigator.of(context, rootNavigator: false)
                        .pushNamed(
                          SingleChatScreen.routeName,
                          arguments: user.username,
                        )
                        .then((_) => chatProvider.currentChat = "");
                  },
                  child: ProfileIcon(user: user),
                );
              },
            ),
    );
  }
}
