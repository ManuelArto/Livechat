import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  final void Function(File image) sendImage;

  const ImagePickerButton(this.sendImage, {Key? key}) : super(key: key);

  @override
  ImagePickerButtonState createState() => ImagePickerButtonState();
}

class ImagePickerButtonState extends State<ImagePickerButton> {
  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final ImageSource? imageSource = await _showDialog();
    if (imageSource != null) {
      final image = await picker.pickImage(source: imageSource, imageQuality: 20);
      if (image != null) {
        widget.sendImage(File(image.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: _pickImage,
        child: const Icon(
          Icons.camera_alt_rounded,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<ImageSource?> _showDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Send an image"),
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
