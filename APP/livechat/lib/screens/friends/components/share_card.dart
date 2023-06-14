import 'package:flutter/material.dart';

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
        title: const Text("Invita amici su Livechat"),
        subtitle: Text("livechat/${user.username}"),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_rounded),
        ),
      ),
    );
  }
}