import 'package:livechat/models/friend.dart';

import 'chat.dart';

class Group extends Chat {
  List<Friend> users;

  Group(String chatName, this.users) : super(chatName: chatName, messages: []);
}
