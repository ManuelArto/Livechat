import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Future<void> Function(Uint8List imageBytes) setUserImage;

  const UserImagePicker(this.setUserImage, {Key? key}) : super(key: key);

  @override
  UserImagePickerState createState() => UserImagePickerState();
}

class UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final ImageSource? imageSource = await _showDialog();
    if (imageSource != null) {
      final image = await picker.pickImage(
        source: imageSource,
        maxWidth: 128,
        maxHeight: 128,
      );
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
        widget.setUserImage(_pickedImage!.readAsBytesSync());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
          child: Text(
            _pickedImage != null ? "" : "No\nimage",
            textAlign: TextAlign.center,
          ),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor),
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text("Add an image"),
        ),
      ],
    );
  }

  Future<ImageSource?> _showDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick an image"),
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.image),
                label: const Text("Album"),
              ),
            ],
          ),
        );
      },
    );
  }
}
