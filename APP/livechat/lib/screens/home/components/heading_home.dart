import 'package:flutter/material.dart';
import '../../../models/auth/auth_user.dart';

class HeadingHome extends StatelessWidget {
  const HeadingHome({
    super.key,
    required this.authUser,
  });

  final AuthUser authUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).secondaryHeaderColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(authUser.imageUrl),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Text("Welcome", style: TextStyle(fontSize: 25, fontFamily: "Roboto"),),
                    const SizedBox(width: 8),
                    Text(authUser.username, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 2.0, top: 5.0),
                  child: Row(
                    children: [
                      Text("LiveChat: Where Connections Come Alive!", style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}