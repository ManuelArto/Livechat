import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/widgets/auth/user_image_picker.dart';
import 'package:livechat/widgets/auth/user_default_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  AuthFormState createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _isLogin = false;
  var _defaultPhoto = true;
  var _isLoading = false;
  final Map<String, dynamic> _authData = {
    "email": "",
    "username": "",
    "password": "",
    "imageFile": null,
  };

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_isLogin && _authData["imageFile"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please pick an Image"),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await Provider.of<Auth>(context, listen: false).signin(
          _authData["email"],
          _authData["password"],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData["email"],
          _authData["username"],
          _authData["password"],
          base64Encode(kIsWeb || _defaultPhoto
              ? _authData["imageFile"]
              : (_authData["imageFile"] as File).readAsBytesSync()),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _pickedImage(File image) {
    _authData["imageFile"] = image;
  }

  Future<void> _pickedDefaultImage(String path) async {
    ByteData bytes = await rootBundle.load(path);
    _authData["imageFile"] = bytes.buffer.asUint8List();
  }

  List<Widget> imageForm() {
    return [
      if (!kIsWeb)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _authData["imageFile"] = null;
              setState(() => _defaultPhoto = !_defaultPhoto);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("Switch Image"),
                Icon(Icons.switch_camera),
              ],
            ),
          ),
        ),
      if (!_defaultPhoto) UserImagePicker(_pickedImage, _authData["imageFile"]),
      if (kIsWeb || _defaultPhoto)
        UserDefaultPicker(_pickedDefaultImage)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin) ...[
                        ...imageForm(),
                        TextFormField(
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          key: const ValueKey("username"),
                          onSaved: (newValue) =>
                              _authData["username"] = newValue?.trim(),
                          validator: (value) {
                            return value == null || value.isEmpty
                                ? "Username must not be empty"
                                : value.contains(" ")
                                    ? "Username must no contain spaces"
                                    : value.length < 6 || value.length > 30
                                        ? "Username must be at 6-30 characters long"
                                        : null;
                          },
                          decoration:
                              const InputDecoration(labelText: "Username"),
                        ),
                      ],
                      TextFormField(
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        key: const ValueKey("email"),
                        onSaved: (newValue) =>
                            _authData["email"] = newValue?.trim(),
                        validator: (value) => value != null &&
                                (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value))
                            ? "Please enter a valide email"
                            : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(labelText: "Email address"),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        key: const ValueKey("password"),
                        onSaved: (newValue) =>
                            _authData["password"] = newValue?.trim(),
                        validator: (value) {
                          return value == null || value.isEmpty
                              ? "Password must not be empty"
                              : value.contains(" ")
                                  ? "Password must no contain any spaces"
                                  : value.length < 7
                                      ? "Password must be at least 7 characters long"
                                      : null;
                        },
                        decoration:
                            const InputDecoration(labelText: "Password"),
                        obscureText: true,
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: const ValueKey("Confirm password"),
                          validator: (value) =>
                              (value != _passwordController.text)
                                  ? "Password doesn't match"
                                  : null,
                          decoration: const InputDecoration(
                              labelText: "Confirm password"),
                          obscureText: true,
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (!_isLoading) ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.8),
                          ),
                          onPressed: _submitForm,
                          child: Text(_isLogin ? "Login" : "SignUp"),
                        ),
                        TextButton(
                          child: Text(_isLogin
                              ? "Create new Account"
                              : "I already have an account"),
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                        ),
                      ],
                      if (_isLoading)
                        const Center(
                          heightFactor: 3,
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
