import 'package:flutter/material.dart';
import 'package:livechat/models/chat/messages/content/file_content.dart';
import 'package:open_filex/open_filex.dart';

class FileMessage extends StatelessWidget {
  final FileContent file;
  final String sender;

  const FileMessage({required this.file, required this.sender, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => OpenFilex.open(file.get().path),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.file_present_rounded,
            size: 48,
          ),
          Flexible(
            child: Text(
              file.get().path.split('/').last.replaceAll("${sender}_", ""),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
