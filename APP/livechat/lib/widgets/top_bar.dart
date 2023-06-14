import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  bool _loggingOut = false;

  void clickLogout() async {
    setState(() => _loggingOut = true);
    Provider.of<AuthProvider>(context, listen: false)
        .logout()
        .then((t) => setState(() => _loggingOut = false));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 20,
      title: Row(
        children: [
          Image.asset('assets/images/logo_nobg.png', height: 35),
          const SizedBox(width: 8), // Aggiungi uno spazio di 8 punti tra il logo e il testo
          const Text(
            'LiveChat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        _loggingOut
            ? Center(
                heightFactor: 3,
                child: CircularProgressIndicator(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
              )
            : PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem(
                    child: Text('About'),
                  ),
                  PopupMenuItem(
                    onTap: clickLogout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
      ],
    );
  }
}
