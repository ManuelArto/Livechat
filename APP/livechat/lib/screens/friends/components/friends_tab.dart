import 'package:flutter/material.dart';
import 'package:livechat/models/friend.dart';

class FriendsTab extends StatelessWidget {
  FriendsTab({Key? key}) : super(key: key);

  final List<Friend> _friends = List.generate(
    50,
    (index) => Friend(
        username: "Username$index", imageUrl: "https://picsum.photos/$index"),
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          alignment: Alignment.topLeft,
          child: Text(
            "MY FRIENDS (${_friends.length})",
            style: TextStyle(
              fontSize: theme.textTheme.bodyLarge!.fontSize,
              fontWeight: theme.textTheme.bodyLarge!.fontWeight,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _friends.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                  bottom: index == _friends.length - 1 ? 250 : 0),
              child: ListTile(
                title: Text(_friends[index].username),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_friends[index].imageUrl),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ],
    );
  }
}
