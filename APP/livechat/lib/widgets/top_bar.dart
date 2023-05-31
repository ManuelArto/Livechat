import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget{
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset('assets/images/logo_nobg.png', height: 50),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 20,
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              child: Text('Settings'),
            ),
            const PopupMenuItem(
              child: Text('About'),
            ),
            PopupMenuItem(
              child: const Text('Logout'),
              onTap: () => Provider.of<AuthProvider>(context, listen: false).logout(),
            ),
          ],
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
