import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/screens/auth/components/user_image_section.dart';

import '../../../models/auth/auth_request.dart';
import '../../../providers/settings_provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  AuthFormState createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  var _isLoading = false;

  final AuthRequest _authRequest = AuthRequest();

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    // Check if the user picked an image
    if (_authRequest.userNeedImage) {
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
      await Provider.of<AuthProvider>(context, listen: false)
          .authenticate(_authRequest);
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<SettingsProvider>(context).settings.darkMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Form(
              key: _formKey,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_authRequest.isLogin) ...[
                      UserImageSection(_authRequest),
                      TextFormField(
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        key: const ValueKey("username"),
                        onSaved: (newValue) =>
                            _authRequest.username = newValue?.trim(),
                        validator: (value) {
                          return value == null || value.isEmpty
                              ? "Username must not be empty"
                              : value.contains(" ")
                                  ? "Username must no contain spaces"
                                  : value.length < 6 || value.length > 15
                                      ? "Username must be 6-15 characters long"
                                      : null;
                        },
                        decoration: InputDecoration(
                            labelText: "Username",
                            fillColor: darkMode ? null : Colors.white),
                      ),
                    ],
                    TextFormField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      key: const ValueKey("email"),
                      onSaved: (newValue) =>
                          _authRequest.email = newValue?.trim(),
                      validator: (value) => value != null &&
                              (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value))
                          ? "Please enter a valide email"
                          : null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email address",
                          fillColor: darkMode ? null : Colors.white),
                    ),
                    if (!_authRequest.isLogin)
                      TextFormField(
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        key: const ValueKey("phone"),
                        onSaved: (newValue) =>
                            _authRequest.phoneNumber = newValue?.trim(),
                        validator: (value) => value != null &&
                                (!RegExp(
                                        r"^\(?\d{1,}\)?[-.\s]?\d{1,}[-.\s]?\d{1,}[-.\s]?\d{1,}[-.\s]?\d{1,}$")
                                    .hasMatch(value))
                            ? "Please enter a valide phone number"
                            : null,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: "Phone Number",
                            fillColor: darkMode ? null : Colors.white),
                      ),
                    TextFormField(
                      controller: _passwordController,
                      key: const ValueKey("password"),
                      onSaved: (newValue) =>
                          _authRequest.password = newValue?.trim(),
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? "Password must not be empty"
                            : value.contains(" ")
                                ? "Password must no contain any spaces"
                                : value.length < 7
                                    ? "Password must be at least 7 characters long"
                                    : null;
                      },
                      decoration: InputDecoration(
                          labelText: "Password",
                          fillColor: darkMode ? null : Colors.white),
                      obscureText: true,
                    ),
                    if (!_authRequest.isLogin)
                      TextFormField(
                        key: const ValueKey("Confirm password"),
                        validator: (value) =>
                            (value != _passwordController.text)
                                ? "Password doesn't match"
                                : null,
                        decoration: InputDecoration(
                            labelText: "Confirm password",
                            fillColor: darkMode ? null : Colors.white),
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
                        child: Text(_authRequest.isLogin ? "Login" : "Sign Up"),
                      ),
                      TextButton(
                        child: Text(_authRequest.isLogin
                            ? "Create new Account"
                            : "I already have an account"),
                        onPressed: () => setState(
                            () => _authRequest.isLogin = !_authRequest.isLogin),
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
    );
  }
}
