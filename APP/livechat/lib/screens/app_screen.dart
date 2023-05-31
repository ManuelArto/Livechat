import 'package:flutter/material.dart';
import 'package:livechat/providers/bottom_bar_notifier.dart';
import 'package:provider/provider.dart';

import '../widgets/bottom_bar.dart';
import '../widgets/top_bar.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomBarNotifier>(
      create: (context) => BottomBarNotifier(),
      builder: (context, child) {
        BottomBarNotifier bottomBarNotifier = Provider.of<BottomBarNotifier>(context);
        return Scaffold(
          appBar: const TopBar(),
          bottomNavigationBar: const BottomBar(),
          body: IndexedStack(
            index: bottomBarNotifier.tabIndex,
            children: bottomBarNotifier.tabScreens,
          ),
        );
      },
    );
  }
}
