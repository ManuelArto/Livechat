import 'package:flutter/material.dart';
import 'package:livechat/models/auth/auth_user.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:livechat/screens/home/components/previews/ranking/user_rank_tile.dart';
import 'package:provider/provider.dart';

import '../../../../models/friend.dart';
import '../../../../models/user.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/steps_provider.dart';
import '../../ranking_screen.dart';

class PreviewRanking extends StatefulWidget {
  const PreviewRanking({super.key});

  @override
  State<PreviewRanking> createState() => _PreviewRankingState();
}

class _PreviewRankingState extends State<PreviewRanking> {
  int myRank = 0;

  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthProvider>(context).authUser!;
    StepsProvider stepsProvider = Provider.of<StepsProvider>(context);
    UsersProvider usersProvider = Provider.of<UsersProvider>(context);

    List<User> ranks = getDailyRanking(authUser, stepsProvider.steps, usersProvider);

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
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ranks.length,
              itemBuilder: (context, index) {
                User user = ranks[index];
                bool isMe = user.username == authUser.username;
                int steps = isMe
                    ? stepsProvider.steps
                    : (user as Friend).steps;

                return UserRankTile(
                  username: user.username,
                  imageUrl: user.imageUrl,
                  totalSteps: steps,
                  position: isMe ? myRank+1 : index+1,
                );
              },
              separatorBuilder: (context, index) => const Divider(thickness: 1),
            ),
          ),
          const Divider(thickness: 1),
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: false)
                .pushNamed(RankingScreen.routeName),
            child: const Text("Show total ranking"),
          ),
        ],
      ),
    );
  }

  List<User> getDailyRanking(AuthUser authUser, int steps, UsersProvider usersProvider) {
    List<User> ranks = List.from(usersProvider.friends)
      ..sort((a, b) => (b as Friend).steps.compareTo((a as Friend).steps));

    myRank = 0;
    while (myRank < ranks.length &&
        steps < (ranks[myRank] as Friend).steps) {
      myRank++;
    }
    ranks.insert(myRank > 2 ? 2 : myRank, authUser);

    return ranks.take(3).toList();
  }
}
