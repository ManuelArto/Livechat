import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:format/format.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../../models/friend.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/http_requester.dart';
import '../dynamic_user_tiles.dart';
import '../user_tile.dart';
import '../user_tiles.dart';

class SuggestedFriendsTab extends StatefulWidget {
  const SuggestedFriendsTab({Key? key}) : super(key: key);

  @override
  State<SuggestedFriendsTab> createState() => _SuggestedFriendsTabState();
}

class _SuggestedFriendsTabState extends State<SuggestedFriendsTab> {
  List<Friend> _contacts = [];

  Future<void> _loadContacts() async {
    final String token =
        Provider.of<AuthProvider>(context, listen: false).authUser!.token;

    if (await FlutterContacts.requestPermission()) {
      // RETRIEVE CONTACT NUMBERS
      List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);
      List<String> phoneNumbers = [];
      for (var contact in contacts) {
        if (contact.phones.isNotEmpty) {
          String number = contact.phones.first.number
              .replaceFirst("+39", "")
              .replaceAll(" ", "")
              .replaceAll(".", "")
              .trim();
          if (RegExp(r"^\d{10}$").hasMatch(number)) {
            phoneNumbers.add(number);
          }
        }
      }

      // RETRIEVE CONTACTS
      _contacts = (await HttpRequester.get(
        URL_FRIENDS_CONTACTS.format(phoneNumbers.join("&numbers=")),
        token,
      ) as List)
          .map((user) => Friend.fromJson(user))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return FutureBuilder(
      future: _loadContacts(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Contacts using Livechat",
                        style: TextStyle(
                          fontSize: theme.textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _contacts.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Text("No contacts found."),
                          ),
                        )
                      : UserTiles(
                          users: _contacts,
                          action: UserAction.ADD,
                          bottomPadding: false,
                        ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "People you might know",
                        style: TextStyle(
                          fontSize: theme.textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const DynamicUserTiles(),
                  const SliverToBoxAdapter(child: SizedBox(height: 250)),
                ],
              );
      },
    );
  }
}
