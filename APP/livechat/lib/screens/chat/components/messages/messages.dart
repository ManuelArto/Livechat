import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/auth/auth_user.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/chat_provider.dart';
import '../../../../providers/friends_provider.dart';
import 'message_bubble.dart';

class Messages extends StatefulWidget {
  final String chatName;

  const Messages(this.chatName, {Key? key}) : super(key: key);

  @override
  MessagesState createState() => MessagesState();
}

class MessagesState extends State<Messages> with AutomaticKeepAliveClientMixin{
  final ScrollController _scrollController = ScrollController();
  late final AuthUser authUser;

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    authUser = Provider.of<AuthProvider>(context, listen: false).authUser!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final friendsProvider = Provider.of<FriendsProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.messages(widget.chatName);

    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = authUser.username == message.sender;
        return MessageBubble(
          message: message,
          isMe: isMe,
          imageUrl: isMe ? authUser.imageUrl : friendsProvider.getFriend(message.sender!).imageUrl,
          key: ValueKey(message.id),
        );
      },
    );
  }
  
  @override
  bool get wantKeepAlive => true;
  
}
