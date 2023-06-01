import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:livechat/models/auth/auth_request.dart';
import 'package:livechat/screens/auth/components/user_default_image_picker.dart';
import 'package:livechat/screens/auth/components/user_image_picker.dart';

class UserImageSection extends StatefulWidget {
  final AuthRequest authRequest;

  const UserImageSection(this.authRequest, {Key? key}) : super(key: key);

  @override
  State<UserImageSection> createState() => _UserImageSectionState();
}

class _UserImageSectionState extends State<UserImageSection> {
  late AuthRequest _authRequest;
  bool _pickDefaultImage = kIsWeb;

  Future<void> _setUserImage(Uint8List imageBytes) async {
    _authRequest.imageFile = base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    _authRequest = widget.authRequest;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (!kIsWeb)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  _authRequest.imageFile = null;
                  setState(() => _pickDefaultImage = !_pickDefaultImage);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Switch Image"),
                    Icon(Icons.switch_camera),
                  ],
                ),
              ),
            ),
          ),
        if (!_pickDefaultImage) UserImagePicker(_setUserImage),
        if (kIsWeb || _pickDefaultImage) UserDefaultPicker(_setUserImage)
      ],
    );
  }
}
