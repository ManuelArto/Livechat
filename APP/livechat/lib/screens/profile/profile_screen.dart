import 'package:flutter/material.dart';
import 'package:livechat/screens/profile/user_edit_screen.dart';
import 'package:livechat/screens/profile/user_settings_screen.dart';
import 'package:livechat/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import '../../models/auth/auth_user.dart';
import '../../providers/auth_provider.dart';
import 'components/about.dart';
import 'components/feedback_rating.dart';
import 'components/profile_menu.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfileScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  late AuthProvider authProvider;

  Route<dynamic>? _buildRoute(settings) {
    switch (settings.name) {
      case UserEditScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const UserEditScreen(),
        );
      case UserSettingsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const UserSettingsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => _buildProfileScreen(context),
        );
    }
  }

  bool _loggingOut = false;
  void clickLogout() async {
    setState(() => _loggingOut = true);
    authProvider.logout().then((t) => setState(() => _loggingOut = false));
  }

  Scaffold _buildProfileScreen(BuildContext context) {
    ThemeData theme = Theme.of(context);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    AuthUser authUser = authProvider.authUser!;

    return Scaffold(
      appBar: const TopBar(),
      body: _loggingOut
          ? Center(
              child: CircularProgressIndicator(
              color: theme.primaryColor,
            ))
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(authUser.imageUrl),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      child: Text(authUser.username,
                          style: theme.textTheme.headlineMedium),
                    ),
                    Text(authUser.email,
                        style: theme.textTheme.bodyMedium),
                    const Divider(),
                    const SizedBox(height: 30),
                    ProfileMenu(
                      title: "Settings",
                      icon: Icons.settings,
                      onPress: () => Navigator.of(context, rootNavigator: false)
                          .pushNamed(UserSettingsScreen.routeName),
                    ),
                    ProfileMenu(
                      title: "Account Settings",
                      icon: Icons.manage_accounts_rounded,
                      onPress: () => Navigator.of(context, rootNavigator: false)
                          .pushNamed(UserEditScreen.routeName),
                    ),
                    ProfileMenu(
                      title: "Feedback",
                      icon: Icons.feedback,
                      onPress: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const FeedbackRating(),
                      ),
                    ),
                    ProfileMenu(
                      title: "About",
                      icon: Icons.info_outline,
                      onPress: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => const About(),
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    ProfileMenu(
                      title: "Logout",
                      icon: Icons.logout,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: clickLogout,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Navigator(
      key: widget.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: _buildRoute,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
