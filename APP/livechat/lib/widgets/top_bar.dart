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

  Future<void> clickLogout() async {
    setState(() {
      _loggingOut = true;
    });
    await Provider.of<AuthProvider>(context, listen: false).logout();
    setState(() {
      _loggingOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset('assets/images/logo_nobg.png', height: 35),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 20,
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
