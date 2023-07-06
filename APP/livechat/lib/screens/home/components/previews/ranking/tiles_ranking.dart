import 'package:flutter/material.dart';
import 'package:livechat/models/friend.dart';
import 'package:livechat/screens/home/components/previews/ranking/user_rank_tile.dart';

class TilesRanking extends StatelessWidget {
  const TilesRanking({Key? key, required this.ranking}) : super(key: key);

  final List<Friend> ranking;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        itemCount: ranking.length,
        separatorBuilder: (context, index) => const Divider(thickness: 1),
        itemBuilder: (context, index) {
          final user = ranking[index];
          return UserRankTile(
            username: user.username,
            imageUrl: user.imageUrl,
            totalSteps: user.steps,
            position: index + 1,
          );
        },
      ),
    );
  }
}
