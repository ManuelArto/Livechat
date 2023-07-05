import 'package:flutter/material.dart';
import 'package:livechat/models/settings.dart';
import 'package:livechat/providers/settings_provider.dart';
import 'package:provider/provider.dart';

import '../../models/auth/auth_user.dart';
import '../../providers/auth_provider.dart';

class UserEditScreen extends StatefulWidget {
  static const routeName = "/editScreen";
  const UserEditScreen({super.key});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  late final Settings _settings;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    AuthUser authUser =
        Provider.of<AuthProvider>(context, listen: false).authUser!;
    _settings = Provider.of<SettingsProvider>(context).settings;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const Text(
                "Account Settings",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(authUser.imageUrl)),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   child: Container(
                    //     height: 40,
                    //     width: 40,
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         border: Border.all(
                    //           width: 4,
                    //           color: Theme.of(context).scaffoldBackgroundColor,
                    //         ),
                    //         color: Colors.blueAccent),
                    //     child: IconButton(
                    //       alignment: Alignment.center,
                    //       iconSize: 15,
                    //       icon: const Icon(Icons.edit),
                    //       color: Colors.white,
                    //       onPressed: () {}, // TODO: modifica immagine
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              const SizedBox(height: 35),
              buildTextField("Username", authUser.username, false),
              buildTextField(
                  "Phone Number", authUser.phoneNumber, false),
              buildTextField("Email", authUser.email, false),
              // buildTextField("New Password", "********", true),
              // buildTextField("Confirm Password", "********", true),
              // _buildbuttons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        enabled: false,
        obscureText: isPassword ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                  ),
                )
              : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.all(10),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _settings.darkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Row _buildbuttons() {
    return Row(
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
            child: TextButton(
              onPressed: () {}, // TODO: salva nuove info
              style: TextButton.styleFrom(
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
    );
  }
}
