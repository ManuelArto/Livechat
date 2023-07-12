import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constants.dart';
import '../../../models/auth/auth_user.dart';

class ShareCard extends StatelessWidget {
  const ShareCard({
    super.key,
    required this.user,
  });

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(user.imageUrl),
        ),
        title: const FittedBox(child: Text("Invite friends on Livechat")),
        subtitle: Text(
          "livechat/${user.username}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: IconButton(
          onPressed: () {
            Share.share(
                "Discover Livechat, the ultimate communication app. Download now!\n$DOWNLOAD_LINK");
          },
          icon: const Icon(Icons.share_rounded),
        ),
      ),
    );
  }
}
