import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:livechat/providers/settings_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../models/chat/messages/message.dart';
import '../../../forward_msg_screen.dart';

class MessageBubble extends StatelessWidget {
  final widgetKey = GlobalKey();

  final Message message;
  final String imageUrl;
  final bool isMe;
  final Widget messageWidget;

  MessageBubble({
    required this.message,
    required this.isMe,
    required this.imageUrl,
    required this.messageWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<SettingsProvider>(context).settings.darkMode;

    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              constraints: BoxConstraints(maxWidth: size.width * 0.8),
              child: ElevatedButton(
                key: widgetKey,
                onPressed: null,
                onLongPress: () {
                  showMenu(
                    items: <PopupMenuEntry>[
                      PopupMenuItem(
                        onTap: () => Navigator.popAndPushNamed(
                          context,
                          ForwardMsgScreen.routeName,
                          arguments: message,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Forward"),
                            Icon(Icons.forward_rounded)
                          ],
                        ),
                      )
                    ],

                    context: context,
                    position: _getRelativeRect(widgetKey),
                  );
                },
                style: _messageStyle(theme, isDarkMode),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 5, left: isMe ? 16 : 0, right: isMe ? 0 : 16),
                      child: Text(
                        message.sender!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    messageWidget,
                  ],
                ),
              ),
            ),
            Positioned(
              top: -5,
              right: isMe ? null : -10,
              left: isMe ? -10 : null,
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(DateFormat("jm").format(message.time!)),
        ),
      ],
    );
  }

  RelativeRect _getRelativeRect(GlobalKey key) {
    return RelativeRect.fromSize(
      _getWidgetGlobalRect(key),
      const Size(50, 50),
    );
  }

  Rect _getWidgetGlobalRect(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return Rect.fromLTWH(
      isMe ? offset.dx : offset.dx - renderBox.size.width,
      offset.dy + renderBox.size.height / 2,
      renderBox.size.width,
      renderBox.size.height,
    );
  }

  ButtonStyle _messageStyle(ThemeData theme, bool isDarkMode) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      backgroundColor: isMe
          ? theme.primaryColor.withOpacity(0.7)
          : theme.secondaryHeaderColor.withOpacity(0.7),
      foregroundColor: isDarkMode ? Colors.white : Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft:
              !isMe ? const Radius.circular(0) : const Radius.circular(20),
          bottomRight:
              isMe ? const Radius.circular(0) : const Radius.circular(20),
        ),
      ),
    );
  }
}
