import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/auth/auth_user.dart';
import '../../../providers/auth_provider.dart';

class HeadingHome extends StatelessWidget {
  const HeadingHome({super.key});

  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthProvider>(context).authUser!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(authUser.imageUrl),
            ),
            FittedBox(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Welcome",
                        style: TextStyle(fontSize: 25, fontFamily: "Roboto"),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        authUser.username,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 2.0, top: 5.0),
                    child: Row(
                      children: [
                        Text("Livechat: Where Connections Come Alive!"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
