import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class UserDefaultPicker extends StatefulWidget {
  final Future<void> Function(Uint8List imageBytes) setUserImage;

  const UserDefaultPicker(this.setUserImage, {Key? key}) : super(key: key);

  @override
  UserDefaultPickerState createState() => UserDefaultPickerState();
}

class UserDefaultPickerState extends State<UserDefaultPicker> {
  int active = -1;

  void setDefaultImage(String path) async{
    ByteData bytes = await rootBundle.load(path);
    widget.setUserImage(bytes.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildButton(
              context, Icons.tag_faces, "profile_icon_male.jpg", "Male", 0),
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: buildButton(
              context, Icons.face_4, "profile_icon_female.png", "Female", 1),
        ),
      ],
    );
  }

  TextButton buildButton(BuildContext context, IconData icon, String imagePath, String type, int activeValue) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: active == activeValue
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
              : Colors.grey[300]),
      onPressed: () {
        setState(() {
          active = activeValue;
          setDefaultImage("assets/images/$imagePath");
        });
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(icon),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(type),
          ),
        ],
      ),
    );
  }
}
