import 'package:flutter/material.dart';
import 'package:livechat/screens/home/components/preview_ranking.dart';
import 'package:livechat/screens/home/components/preview_steps.dart';
import '../../../models/auth/auth_user.dart';
import 'chats_preview.dart';

class PageViewHome extends StatefulWidget {
  const PageViewHome({
    super.key,
    required this.authUser
  });

  final AuthUser authUser;

  @override
  State<PageViewHome> createState() => _PageViewHomeState();
}

class _PageViewHomeState extends State<PageViewHome> {
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  final int totalPages = 3;

  final PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.9,
  );


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: pageController,
        onPageChanged: (int index) {
          currentPageNotifier.value = index % totalPages;
        },
        itemBuilder: (BuildContext context, int index) {
          int pageIndex = index % totalPages;
          if (pageIndex == 0) {
            return PreviewRanking(authUser: widget.authUser);
          } else if (pageIndex == 1) {
            return const PreviewSteps();
          } else if (pageIndex == 2) {
            return ChatsPreview(authUser: widget.authUser);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  
}
