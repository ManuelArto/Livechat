import 'package:flutter/material.dart';
import 'package:livechat/models/settings.dart';
import 'package:livechat/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class UserRankTile extends StatelessWidget {
  const UserRankTile({
    Key? key,
    required this.username,
    required this.position,
    required this.totalSteps,
    required this.imageUrl,
  }) : super(key: key);

  final String username;
  final int position;
  final int totalSteps;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<SettingsProvider>(context).settings;

    return ListTile(
      leading: SizedBox(
        width: 90,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: position == 1
                    ? Colors.yellow[400]
                    : position == 2
                        ? Colors.grey[400]
                        : position == 3
                            ? Colors.brown[400]
                            : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  position.toString(),
                  style: TextStyle(
                    color: position == 1
                        ? Colors.red
                        : position == 2
                            ? Colors.black
                            : position == 3 || settings.darkMode
                                ? Colors.white
                                : Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ],
        ),
      ),
      title:
          Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Total steps: ${totalSteps.toString()}'),
    );
  }
}
