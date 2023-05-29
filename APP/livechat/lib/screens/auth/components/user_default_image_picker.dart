import 'package:flutter/material.dart';

class UserDefaultPicker extends StatefulWidget {
  final Function pickedImageWeb;

  const UserDefaultPicker(this.pickedImageWeb, {super.key});

  @override
  UserDefaultPickerState createState() => UserDefaultPickerState();
}

class UserDefaultPickerState extends State<UserDefaultPicker> {
  int active = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildButton(
              context, Icons.tag_faces, "profile_icon_male.jpg", "Male"),
        ),
        Expanded(
          child: buildButton(
              context, Icons.face, "profile_icon_female.png", "Female"),
        ),
      ],
    );
  }

  TextButton buildButton(BuildContext context, IconData icon, String imagePath, String type) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: active == (type == "Male" ? 1 : 0)
              ? Theme.of(context).colorScheme.secondary
              : Colors.grey[300]),
      onPressed: () {
        setState(() {
          active = (type == "Male" ? 1 : 0);
          widget.pickedImageWeb("assets/images/$imagePath");
        });
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(icon),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: Text(type, maxLines: 1),
          ),
        ],
      ),
    );
  }
}
