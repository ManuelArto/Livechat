import 'package:flutter/material.dart';
import 'package:livechat/models/chat/messages/content/audio_content.dart';
import 'package:livechat/models/chat/messages/content/content.dart';
import 'package:livechat/models/chat/messages/content/image_content.dart';
import 'package:livechat/models/chat/messages/content/text_content.dart';
import 'package:livechat/screens/chat/components/single_chat/messages/image_message.dart';
import 'package:provider/provider.dart';

import '../../../../../models/auth/auth_user.dart';
import '../../../../../models/chat/messages/message.dart';
import '../../../../../providers/auth_provider.dart';
import '../../../../../providers/chat_provider.dart';
import '../../../../../providers/friends_provider.dart';
import 'audio_message_player.dart';
import 'message_bubble.dart';

class Messages extends StatefulWidget {
  final String chatName;

  const Messages(this.chatName, {Key? key}) : super(key: key);

  @override
  MessagesState createState() => MessagesState();
}

class MessagesState extends State<Messages> with AutomaticKeepAliveClientMixin {
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

    final friendsProvider =
        Provider.of<FriendsProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.messages(widget.chatName);

    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = authUser.username == message.sender;

        Widget messageWidget = _buildChildMessageWidget(message, isMe);

        return MessageBubble(
          message: message,
          isMe: isMe,
          imageUrl: isMe
              ? authUser.imageUrl
              : friendsProvider.getFriend(message.sender!).imageUrl,
          key: ValueKey(message.id),
          messageWidget: messageWidget,
        );
      },
    );
  }

  Widget _buildChildMessageWidget(Message<Content> message, bool isMe) {
    switch (message.content.runtimeType) {
      case TextContent:
        return Text(
          message.content!.get(),
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.justify,
        );
      case AudioContent:
        return AudioMessagePlayer(
          audio: message.content as AudioContent,
          key: ValueKey(message.id),
        );
      case ImageContent:
        return ImageMessage(image: message.content as ImageContent);
      default:
        throw UnsupportedError(
          "Message content ${message.content.runtimeType} not supported",
        );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
