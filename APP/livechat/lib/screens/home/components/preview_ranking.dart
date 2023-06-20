import 'package:flutter/material.dart';
import 'package:livechat/screens/home/components/ranking/ranking_steps.dart';

import '../../../models/auth/auth_user.dart';
import '../ranking_screen.dart';

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
          const SizedBox(height: 15),
          const Text("Classifica giornaliera",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(thickness: 1),
          RankingSteps(
            username: "naepols-01",
            position: 1,
            totalSteps: 1973,
            authUser: authUser,
          ),
          const Divider(thickness: 1),
          RankingSteps(
            username: "franco",
            position: 2,
            totalSteps: 1720,
            authUser: authUser,
          ),
          const Divider(thickness: 1),
          RankingSteps(
            username: "ueuemanu",
            position: 3,
            totalSteps: 1202,
            authUser: authUser,
          ),
          const Divider(thickness: 1),
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: false)
                          .pushNamed(RankingScreen.routeName),
            child: const Text("View total ranking"),
          ),
        ],
      ),
    );
  }
}
