import 'package:flutter/material.dart';
import 'package:livechat/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import '../../models/auth/auth_user.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfileScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    int val = 6;

    AuthUser authUser = Provider.of<AuthProvider>(context).authUser!;

    return Scaffold(
      appBar: const TopBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width:120, 
                    height:120,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(authUser.imageUrl),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blueAccent
                      ),
                      child: const Icon(
                        Icons.edit, 
                        size: 20.0, 
                        color: Colors.black
                      )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(authUser.username, style: Theme.of(context).textTheme.headlineMedium),
              Text("andreanapoli@gmail.com", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: (){}, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, side: BorderSide.none, shape: const StadiumBorder()
                  ),
                  child: const Text("Edit Profile"))
              ),
              const Divider(),
              const SizedBox(height: 10),
              Column(
                children: [
                   SizedBox(
                    height: 150.0,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                                value: val/10,
                                strokeWidth: 18, 
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  val<2.5? Colors.red
                                      : val < 5? Colors.orange
                                          : val < 7.5 ? Colors.blue
                                              : Colors.green,
                                ),
                                backgroundColor: Colors.grey, // Colore di sfondo del grafico
                            ),
                          ),
                        ),
                        Center(child: Text("${val*1000}/10000", style: const TextStyle(fontSize: 20)),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10), // Aggiunge uno spazio inferiore di 10 punti
                    child: ProfileMenuWidget(title: "Settings", icon: Icons.settings, onPress: (){}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10), // Aggiunge uno spazio inferiore di 10 punti
                    child: ProfileMenuWidget(title: "Account Settings", icon: Icons.manage_accounts_rounded, onPress: (){}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10), // Aggiunge uno spazio inferiore di 10 punti
                    child: ProfileMenuWidget(title: "About", icon: Icons.info_outline, onPress: (){}),
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10), // Aggiunge uno spazio verticale di 10 punti
                  ProfileMenuWidget(title: "Logout", icon: Icons.logout, textColor: Colors.red, endIcon: false, onPress: (){}),
                ],
              )
                    
            ]
          )
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blueAccent.withOpacity(0.1)
        ),
        child: Icon(icon, color: endIcon? Colors.blueAccent: Colors.red, size: 30.0)
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor, fontSizeDelta: 4)),
      trailing: endIcon? Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Icon(Icons.arrow_forward_ios_outlined, size: 18.0, color: Colors.grey)
      ) : null,
    );
  }
}