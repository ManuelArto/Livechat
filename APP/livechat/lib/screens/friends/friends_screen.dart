  import 'package:flutter/material.dart';
  import 'package:livechat/widgets/top_bar.dart';
  import 'package:provider/provider.dart';

  import '../../models/auth/auth_user.dart';
  import '../../providers/auth_provider.dart';

  class FriendsScreen extends StatefulWidget {
    final GlobalKey<NavigatorState> navigatorKey;

    const FriendsScreen({required this.navigatorKey, Key? key}) : super(key: key);

    @override
    State<FriendsScreen> createState() => _FriendsScreenState();
  }

  class _FriendsScreenState extends State<FriendsScreen> with AutomaticKeepAliveClientMixin{
    bool showPassword = false;
    DateTime date = DateTime(2001, 08, 08);
    @override
    Widget build(BuildContext context) {
      super.build(context);
      AuthUser authUser = Provider.of<AuthProvider>(context).authUser!;

      return Scaffold(
        appBar: const TopBar(),
        body: Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children:[
                const Text(
                  "Account Settings",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130, 
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4, 
                            color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0,10)
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(authUser.imageUrl)
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4, 
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.blueAccent
                          ),
                          child: const Icon(
                            Icons.edit, 
                            color: Colors.white, 
                          ),
                        )
                      )
                    ]
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                buildTextField("Username", "naepols-01", false, false),
                buildTextField("Date of Birth", "${date.day}/${date.month}/${date.year}", true, false),
                buildTextField("Phone Number", "3402141216", false, false),
                buildTextField("Email", "andreanapoli@gmail.com", false, false),
                buildTextField("New Password", "********", false, true),
                buildTextField("Confirm Password", "********", false, true),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 120,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "CANCEL",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 2.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "SAVE",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 2.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ),
          )
        ),
      );
    }

    Widget buildTextField(String labelText, String placeholder, bool isDate, bool isPassword) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: TextField(
          obscureText: isPassword ? showPassword : false,
          onTap: () async {
            if (isDate) {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(1900),
                lastDate: DateTime(2023),
              );
              if (pickedDate != null) {
                setState(() {
                  date = pickedDate;
                });
              }
            }
          },
          decoration: InputDecoration(
            suffixIcon: isPassword ? IconButton(
              onPressed: (){
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            ) : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight:FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    @override
    bool get wantKeepAlive => true;
  }