import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:livechat/models/friend.dart';

import 'user_tile.dart';

class ScrollUserTiles extends StatefulWidget {
  const ScrollUserTiles({Key? key}) : super(key: key);

  @override
  State<ScrollUserTiles> createState() => _ScrollUserTilesState();
}

class _ScrollUserTilesState extends State<ScrollUserTiles> {
  static const _pageSize = 20;

  final PagingController<int, Friend> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
  _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<List<Friend>> getRoba(int pageKey, int pageSize) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return pageKey < 5
        ? List.generate(
            pageSize,
            (index) => Friend(
              username: "Username${index + pageSize * pageKey}",
              imageUrl: "https://picsum.photos/${index + pageSize * pageKey}",
              email: "email${index + pageSize * pageKey}",
              phoneNumber: "phoneNumber${index + pageSize * pageKey}",
            ),
          )
        : [];
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // final List<Friend> newItems = await RemoteApi.getCharacterList(pageKey, _pageSize);
      final List<Friend> newItems = await getRoba(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverList<int, Friend>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Friend>(
        itemBuilder: (context, user, index) => UserTile(
          user: user,
          buttonText: "ADD",
          bottomPadding: _pagingController.nextPageKey == null &&
                  index == _pagingController.itemList!.length - 1
              ? 250
              : 0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
