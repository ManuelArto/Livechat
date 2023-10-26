import 'package:flutter/material.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:provider/provider.dart';

import '../user_tile.dart';
import '../user_tiles.dart';

class FriendsRequestsTab extends StatefulWidget {
  const FriendsRequestsTab({Key? key}) : super(key: key);

  @override
  State<FriendsRequestsTab> createState() => _FriendsRequestsTabState();
}

class _FriendsRequestsTabState extends State<FriendsRequestsTab> {
  late UsersProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    usersProvider = Provider.of<UsersProvider>(context, listen: false);
    ThemeData theme = Theme.of(context);

    return FutureBuilder(
      future: usersProvider.loadRequests(),
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
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          margin: const EdgeInsets.all(5),
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
                      ),
                    ],
                  ),
                ),
              ),
              const UserTilesWrapper(),
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
        return ChangeNotifierProvider.value(
          value: usersProvider,
          child: Column(
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
                child: usersProvider.mineRequests.isEmpty
                    ? const Center(
                        child: Text("No request sended yet"),
                      )
                    : CustomScrollView(
                        slivers: [
                          UserTiles(
                              users: usersProvider.mineRequests,
                              action: UserAction.REJECT)
                        ],
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}

class UserTilesWrapper extends StatelessWidget {
  const UserTilesWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);

    return usersProvider.requests.isEmpty
        ? const SliverFillRemaining(
            child: Center(
              child: Text("No request yet"),
            ),
          )
        : UserTiles(
            users: usersProvider.requests,
            action: UserAction.ACCEPT,
          );
  }
}