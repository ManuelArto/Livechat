import 'package:flutter/material.dart';
import 'package:livechat/screens/home/components/previews/ranking/user_rank_tile.dart';

import '../../../../models/auth/auth_user.dart';
import '../../ranking_screen.dart';

class PreviewRanking extends StatelessWidget {
  const PreviewRanking({
    super.key,
    required this.authUser,
  });

  final AuthUser authUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Daily Ranking",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Divider(thickness: 1),
          UserRankTile(
            username: "naepols-01",
            position: 1,
            totalSteps: 1973,
            authUser: authUser,
          ),
          const Divider(thickness: 1),
          UserRankTile(
            username: "franco",
            position: 2,
            totalSteps: 1720,
            authUser: authUser,
          ),
          const Divider(thickness: 1),
          UserRankTile(
            username: "ueuemanu",
            position: 3,
            totalSteps: 1202,
            authUser: authUser,
          ),
          const Divider(thickness: 1),
          Flexible(
            child: TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: false)
                  .pushNamed(RankingScreen.routeName),
              child: const Text("View total ranking"),
            ),
          ),
        ],
      ),
    );
  }
}
