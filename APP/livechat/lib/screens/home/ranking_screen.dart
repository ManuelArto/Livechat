import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';
import 'components/ranking/classifica_totale.dart';

class RankingScreen extends StatefulWidget {
  static const routeName = "/rankingScreen";

  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>{
  int currentIndex = 0;

  final PageController _pageController = PageController();
  bool isDailyRankingSelected = true;
  bool isWeeklyRankingSelected = false;

  static List<User> dailyRanking = [
    User('andreanapoli01', 5000),
    User('franco', 7000),
    User('alessia', 3000),
    User('Utente 4', 1000),
    User('alice98', 4500),
    User('peterpan', 8000),
    User('giovanna23', 2000),
    User('mariorossi', 12000),
    User('giuliasmith', 6000),
    User('lucamoretti', 4000),
    User('sara85', 5500),
    User('michele72', 9000),
    User('veronicabianchi', 3500),
    User('matteo03', 7500),
    User('elenaverdi', 1000),
    User('paolacosta', 11000),
    User('davidebianchi', 6500),
    User('laurarossi', 2500),
    User('gabrielemarino', 9500),
    User('silvia89', 1500),
  ];

  static List<User> weeklyRanking = [
    User('andreanapoli01', 15000),
    User('franco', 10000),
    User('alessia', 8000),
    User('Utente 4', 3000),
    User('alice98', 19000),
    User('peterpan', 26000),
    User('giovanna23', 15000),
    User('mariorossi', 17500),
    User('giuliasmith', 15000),
    User('lucamoretti', 12000),
    User('sara85', 6000),
    User('michele72', 14000),
    User('veronicabianchi', 10000),
    User('matteo03', 21000),
    User('elenaverdi', 6000),
    User('paolacosta', 18000),
    User('davidebianchi', 9000),
    User('laurarossi', 7000),
    User('gabrielemarino', 16000),
    User('silvia89', 7000),
  ];

    List<TabItem> tabs = [
      TabItem(
        title: const Text("Classifica giornaliera"),
        content: ClassificaTotale(dailyRanking: dailyRanking, weeklyRanking: []),
      ),
      TabItem(
        title: const Text("Classifica settimanale"),
        content: ClassificaTotale(weeklyRanking: weeklyRanking, dailyRanking: []),
      ),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
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
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? Theme.of(context).secondaryHeaderColor
                            : Colors.transparent,
                      ),
                      child: Text(
                        tabs[index].title is Text ? (tabs[index].title as Text).data! : '',
                        style: TextStyle(
                          fontWeight: index == currentIndex
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: index == currentIndex ? 16 : 13,
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
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: tabs.map((tab) => tab.content).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabItem {
  final Widget title;
  final Widget content;

  TabItem({required this.title, required this.content});
}
