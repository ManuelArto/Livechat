import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:livechat/constants.dart';
import 'package:livechat/models/friend.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../services/http_requester.dart';
import 'user_tile.dart';

class DynamicUserTiles extends StatefulWidget {
  const DynamicUserTiles({Key? key}) : super(key: key);

  @override
  State<DynamicUserTiles> createState() => _DynamicUserTilesState();
}

class _DynamicUserTilesState extends State<DynamicUserTiles> {
  static const _pageSize = 20;
  late final String token;

  final PagingController<int, Friend> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    token = Provider.of<AuthProvider>(context, listen: false).authUser!.token;
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<Friend> newItems = (await HttpRequester.get(
        URL_FRIENDS_SUGGESTED.format(pageKey, _pageSize),
        token,
      ) as List)
          .map((user) => Friend.fromJson(user))
          .toList();
          
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
          friend: user,
          action: UserAction.ADD,
        ),
      ),
    );
  }

}
