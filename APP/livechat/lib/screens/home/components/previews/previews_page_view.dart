import 'package:flutter/material.dart';
import 'package:livechat/screens/home/components/previews/preview_ranking.dart';
import 'package:livechat/screens/home/components/previews/preview_steps.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'preview_chats.dart';

class PreviewsPageView extends StatefulWidget {
  const PreviewsPageView({super.key});

  @override
  State<PreviewsPageView> createState() => _PreviewsPageViewState();
}

class _PreviewsPageViewState extends State<PreviewsPageView> {
  final int totalPages = 3;

  final PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.9,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 3.0),
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: const WormEffect(),
            onDotClicked: (index) => pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            ),
          ),
        ),
        SizedBox(
          height: 390,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            itemBuilder: (BuildContext context, int index) {
              int pageIndex = index % totalPages;
              if (pageIndex == 0) {
                return const PreviewRanking();
              } else if (pageIndex == 1) {
                return const PreviewSteps();
              } else if (pageIndex == 2) {
                return const PreviewChats();
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}
