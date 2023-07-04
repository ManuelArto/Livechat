import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
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
        title: const Text("Invite friends on Livechat"),
        subtitle: Text("livechat/${user.username}"),
        trailing: IconButton(
          onPressed: () {
            Share.share("Discover Livechat, the ultimate communication app. Download now!\nhttps://www.facebook.com/watch/?v=298873375806313&extid=CL-UNK-UNK-UNK-AN_GK0T-GK1C&mibextid=2Rb1fB&ref=sharing");
          },
          icon: const Icon(Icons.share_rounded),
        ),
      ),
    );
  }
}