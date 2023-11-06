import 'package:flutter/material.dart';
import 'package:livechat/providers/navbar_notifier.dart';
import 'package:livechat/screens/chat/trusted_screen.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    NavbarNotifier navbarNotifier = Provider.of<NavbarNotifier>(context);

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 20,
      title: Row(
        children: [
          Image.asset('assets/images/logo_nobg.png', height: 35),
          const SizedBox(width: 8),
          const Text(
            'Livechat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: navbarNotifier.tabIndex == Pages.chatsScreen.index,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(TrustedScreen.routeName);
            },
            icon: const Icon(Icons.key_rounded)
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
