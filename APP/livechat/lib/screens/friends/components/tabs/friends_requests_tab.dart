import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../../models/friend.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/http_requester.dart';
import '../user_tile.dart';
import '../user_tiles.dart';

class FriendsRequestsTab extends StatefulWidget {
  const FriendsRequestsTab({Key? key}) : super(key: key);

  @override
  State<FriendsRequestsTab> createState() => _FriendsRequestsTabState();
}

class _FriendsRequestsTabState extends State<FriendsRequestsTab> {
  late List<Friend> _requests;
  late List<Friend> _mineRequests;

  Future<void> _loadRequests() async {
    String token =
        Provider.of<AuthProvider>(context, listen: false).authUser!.token;

    _requests = (await HttpRequester.get(
      URL_REQUESTS_LIST.format("false"),
      token,
    ) as List)
        .map((user) => Friend.fromJson(user["sender"]))
        .toList();

    _mineRequests = (await HttpRequester.get(
      URL_REQUESTS_LIST.format("true"),
      token,
    ) as List)
        .map((user) => Friend.fromJson(user["receiver"]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return FutureBuilder(
      future: _loadRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "FRIEND REQUESTS",
                        style: TextStyle(
                          fontSize: theme.textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showBottomModal(context, theme),
                        child: Row(
                          children: [
                            Text(
                              "Sended",
                              style: TextStyle(
                                fontSize: theme.textTheme.bodyMedium!.fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_sharp, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _requests.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text("No request yet"),
                      ),
                    )
                  : UserTiles(
                      users: _requests,
                      action: UserAction.ACCEPT,
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 250)),
            ],
          );
        }
      },
    );
  }

  void _showBottomModal(BuildContext context, ThemeData theme) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Sended Requests',
                style: TextStyle(
                  fontSize: theme.textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: _mineRequests.isEmpty
                  ? const Center(
                      child: Text("No request sended yet"),
                    )
                  : CustomScrollView(
                      slivers: [UserTiles(users: _mineRequests, action: UserAction.REJECT)],
                    ),
            )
          ],
        );
      },
    );
  }
}
