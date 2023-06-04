import 'package:livechat/models/user.dart';

import 'chat.dart';

class Group extends Chat {
  List<User> users;

  Group(String chatName, this.users) : super(chatName: chatName, messages: []);
}
