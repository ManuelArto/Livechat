import 'package:flutter/material.dart';
import 'package:livechat/screens/home/components/previews/ranking/tiles_ranking.dart';

import '../../../../../models/friend.dart';


class PageViewRanking extends StatefulWidget {
  const PageViewRanking({
    super.key,
    required this.dailyRank,
    required this.weeklyRank,
  });

  final List<Friend> dailyRank;
  final List<Friend> weeklyRank;

  @override
  State<PageViewRanking> createState() => _PageViewRankingState();
}

class _PageViewRankingState extends State<PageViewRanking> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: index == currentPage
                        ? Theme.of(context).secondaryHeaderColor
                        : Colors.transparent,
                  ),
                  child: Text(
                    index == 0 ? "Daily Ranking" : "Weekly Ranking",
                    style: TextStyle(
                      fontWeight: index == currentPage
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: index == currentPage ? 16 : 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => currentPage = page),
            children: [
              TilesRanking(ranking: widget.dailyRank),
              TilesRanking(ranking: widget.weeklyRank),
            ],
          ),
        ),
      ],
    );
  }
}
