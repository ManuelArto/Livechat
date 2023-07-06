import 'package:flutter/material.dart';
import 'package:livechat/screens/home/components/previews/ranking/page_view_ranking.dart';
import 'package:livechat/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/friend.dart';
import '../../providers/auth_provider.dart';
import '../../services/http_requester.dart';

class RankingScreen extends StatefulWidget {
  static const routeName = "/rankingScreen";

  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Friend> _dailyRank = [];
  List<Friend> _weeklyRank = [];

  Future<void> _getRankings() async {
    final String token =
        Provider.of<AuthProvider>(context, listen: false).authUser!.token;
    _dailyRank = (await HttpRequester.get(
      URL_DAILY_RANKING,
      token,
    ) as List)
        .map((user) => Friend.fromJson(user))
        .toList();

    _weeklyRank = (await HttpRequester.get(
      URL_WEEKLY_RANKING,
      token,
    ) as List)
        .map((user) => Friend.fromJson(user))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _getRankings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if ((snapshot.hasError && snapshot.error is String)) {
              return Center(child: Text(snapshot.error.toString()));
            }

            return PageViewRanking(
              dailyRank: _dailyRank,
              weeklyRank: _weeklyRank,
            );
          },
        ),
      ),
    );
  }
}
