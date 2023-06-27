import 'package:flutter/material.dart';
import '../../../models/auth/auth_user.dart';

class ChatsPreview extends StatelessWidget {
  ChatsPreview({
    Key? key,
    required this.authUser,
  }) : super(key: key);

  final AuthUser authUser;

  final List<Map<String, String>> chatList = [
    {
      'user': 'Mamma',
      'message': 'Quando vieni passi dalla cantina?',
    },
    {
      'user': 'Amore',
      'message': "Sto studiando, l'esame di domani è peso",
    },
    {
      'user': 'Simo',
      'message': 'Tu ci sei stasera?',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Recent Chats',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (chatList.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No chats yet', style: TextStyle(fontSize: 20)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(authUser.imageUrl),
                      ),
                      title: Text(chat['user']!),
                      subtitle: Text(chat['message']!),
                    ),
                    const Divider(thickness: 1),
                  ],
                );
              },
            ),
          if (chatList.isNotEmpty)
            TextButton(
              onPressed: () {},
              child: const Text('View chats'),
            ),
        ],
      ),
    );
  }
}
