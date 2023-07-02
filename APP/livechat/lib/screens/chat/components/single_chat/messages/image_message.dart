import 'package:flutter/material.dart';
import 'package:livechat/models/chat/messages/content/image_content.dart';

class ImageMessage extends StatelessWidget {
  final ImageContent image;

  const ImageMessage({required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: image.get().path,
        child: Image.file(
          image.get(),
          height: 148,
        ),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Hero(
            tag: image.get().path,
            child: Image.file(image.get()),
          ),
        ),
      ),
    );
  }
}
