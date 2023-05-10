import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/providers/socket_provider.dart';
import 'package:livechat/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

import 'package:livechat/widgets/active_users.dart';
import 'package:livechat/widgets/home_chats_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/";

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() { 
    super.initState();
    Provider.of<SocketProvider>(context, listen: false).init();
  }
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GradienBackGround(MediaQuery.of(context).size.height * .7),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Chat with\nfriends",
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          size: 35,
                          color: Colors.white70,
                        ),
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: "logout",
                            child: ListTile(
                              trailing: Text("Logout"),
                              title: Icon(Icons.exit_to_app, size: 30),
                            ),
                          )
                        ],
                        onSelected: (value) => auth.logout(),
                      ),
                    ],
                  ),
                ),
                ActiveUsers(screenSize),
                MessagesList(screenSize),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
