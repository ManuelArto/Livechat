import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSettingsScreen extends StatefulWidget {
  static const routeName = "/settingsScreen";
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  int goalStep = 10000;
  int pin = 0000;
  bool appLock = false;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerPIN = TextEditingController();
  Color color = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            changeStep(context),
            const SizedBox(height: 25),
            Row(
              children: [
                Icon(Icons.person, color: color),
                const SizedBox(
                  width: 8,
                ),
                const Text("Theme",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))
              ],
            ),
            const Divider(height: 15, thickness: 2),
            const SizedBox(height: 10),
            changeColorTheme(context),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    value: false,
                    onChanged: (bool val) {}, // TODO: salva dark mode
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Icon(Icons.lock, color: color),
                const SizedBox(
                  width: 8,
                ),
                const Text("App Lock",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            changePin(context)
          ],
        ),
      ),
    );
  }

  Widget changeColorTheme(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Change color of theme'),
                // FlexScheme.values // TODO: radio con lista temi
                content: null,
                actions: [
                  ElevatedButton(
                    child: const Text('Conferma'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Change color",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget changeStep(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Imposta un numero'),
                content: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                ),
                actions: [
                  ElevatedButton(
                    child: const Text('Conferma'),
                    onPressed: () {
                      String numberText = _controller.text;
                      int number = int.tryParse(numberText) ?? 0;
                      setState(() {
                        goalStep = number;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Change goal steps",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Row(
            children: [
              Text(goalStep.toString(),
                  style: const TextStyle(color: Colors.grey)),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget changePin(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "App Lock",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                  value: appLock,
                  onChanged: (bool val) {
                    setState(() {
                      appLock = val;
                      if (appLock) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Imposta un PIN'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      obscureText: true,
                                      controller: _controllerPIN,
                                      keyboardType: TextInputType.number,
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
                                        child: const Text('Annulla',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        onPressed: () {
                                          setState(() {
                                            appLock = false;
                                            _controllerPIN.text = "";
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        child: const Text('Conferma'),
                                        onPressed: () {
                                          String numberText =
                                              _controllerPIN.text;
                                          int number =
                                              int.tryParse(numberText) ?? 0;
                                          if (numberText.length >= 6) {
                                            setState(() {
                                              pin = number;
                                              _controllerPIN.text = "";
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      }
                    });
                  }))
        ],
      ),
    );
  }
}
