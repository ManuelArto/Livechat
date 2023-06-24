import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/navbar_notifier.dart';

class CardHome extends StatefulWidget {
  const CardHome({
    Key? key,
    required this.imgURL,
    required this.nameCard,
    required this.description,
  }) : super(key: key);

  final String imgURL;
  final String nameCard;
  final String description;

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  @override
  Widget build(BuildContext context) {
    NavbarNotifier navbarNotifier =
        Provider.of<NavbarNotifier>(context, listen: false);
    Pages page;

    switch (widget.nameCard) {
      case 'Chat':
        page = Pages.chatsScreen;
        break;
      case 'Map':
        page = Pages.mapViewScreen;
        break;
      case 'Friends':
        page = Pages.friendsScreen;
        break;
      case 'Profile':
        page = Pages.profileScreen;
        break;
      default:
        page = Pages.homeScreen;
    }

    return InkWell(
      onTap: () {
        navbarNotifier.changePage(page);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              widget.imgURL,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(widget.nameCard,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              widget.description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}