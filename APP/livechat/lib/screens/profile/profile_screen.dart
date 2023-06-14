import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:livechat/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import '../../models/auth/auth_user.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/profile_menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfileScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  double rating = 0;

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
                ],
              ),
              const SizedBox(height: 10),
              Text(authUser.username, style: Theme.of(context).textTheme.headlineMedium),
              Text("andreanapoli@gmail.com", style: Theme.of(context).textTheme.bodyMedium),
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
                                backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                        Center(child: Text("${val*1000}/10000", style: const TextStyle(fontSize: 20)),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10), 
                    child: ProfileMenuWidget(title: "Settings", icon: Icons.settings, onPress: (){}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10), 
                    child: ProfileMenuWidget(title: "Account Settings", icon: Icons.manage_accounts_rounded, onPress: (){}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10), 
                    child: ProfileMenuWidget(title: "Feedback", icon: Icons.feedback, onPress: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Lascia un feedback'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RatingBar.builder(
                                  initialRating: rating,
                                  minRating: 0,
                                  maxRating: 5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 30,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (newRating) {
                                    rating = newRating;
                                  },
                                ),
                                const SizedBox(height: 16),
                                const TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Inserisci il tuo feedback',
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                style: 
                                  ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300], 
                                  ),
                                child: const Text('Annulla', style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Invia'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10), 
                    child: ProfileMenuWidget(title: "About", icon: Icons.info_outline, onPress: (){
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Informazioni sull\'app', style: TextStyle(fontSize: 25)),
                            content: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Benvenuto nella nostra app di messaggistica e social networking!',
                                  style: TextStyle(fontSize: 17)
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Caratteristiche principali:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                                ),
                                SizedBox(height: 6),
                                Text('- Scambio di messaggi e richieste di amicizia', style: TextStyle(fontSize: 17)),
                                SizedBox(height: 6),
                                Text('- Chat individuali e creazione di gruppi', style: TextStyle(fontSize: 17)),
                                SizedBox(height: 6),
                                Text('- Mappa per visualizzare la posizione in tempo reale degli amici', style: TextStyle(fontSize: 17)),
                                SizedBox(height: 6),
                                Text('- Classifica con contapassi per tenere traccia dell\'attività fisica', style: TextStyle(fontSize: 17)),
                                SizedBox(height: 16),
                                Text(
                                  'Grazie per aver scelto la nostra app! Buon divertimento!',
                                  style: TextStyle(fontSize: 17)
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      'Version:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8),
                                    Text('1.0.1'),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      'Release:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8),
                                    Text('9 luglio 2023'),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      'Authors:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Manuel Arto, Andrea Napoli', style: TextStyle(fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300], 
                                    ),
                                    child: const Text('Chiudi', style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          );
                        }
                      );
                    }),
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10), 
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
