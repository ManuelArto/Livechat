import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function imagePickFn;
  File? _pickedImage;
  UserImagePicker(this.imagePickFn, this._pickedImage, {super.key});

  @override
  UserImagePickerState createState() => UserImagePickerState();
}

class UserImagePickerState extends State<UserImagePicker> {
  
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
          widget._pickedImage = File(image.path);
        });
        widget.imagePickFn(widget._pickedImage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: widget._pickedImage != null
              ? FileImage(File(widget._pickedImage!.path))
              : null,
          child: Text(
            widget._pickedImage != null ? "" : "Select\nimage",
          ),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor
          ),
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text("add image"),
        ),
      ],
    );
  }

  Future<ImageSource?> _showDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera),
                    Text("CAMERA"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera),
                    Text("ALBUM"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
