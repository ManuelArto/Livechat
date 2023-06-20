import 'package:flutter/material.dart';

import '../../../../models/auth/auth_user.dart';

class RankingSteps extends StatelessWidget {
  const RankingSteps({
    Key? key,
    required this.username,
    required this.position,
    required this.totalSteps,
    required this.authUser,
  }) : super(key: key);

  final AuthUser authUser;
  final String username;
  final int position;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width:90,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: position == 1 ? Colors.yellow[400] : 
                position == 2 ? Colors.grey[400] : Colors.brown[400],
              ),
              child: Center(
                child: Text(
                  position.toString(),
                  style: TextStyle(
                    color: position == 1 ? Colors.red :
                    position == 2 ? Colors.black : Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(authUser.imageUrl),
            ),
          ],
        ),
      ),
      title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Passi totali: ${totalSteps.toString()}'),
    );
  }
}