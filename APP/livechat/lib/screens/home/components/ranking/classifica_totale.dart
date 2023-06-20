import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/auth/auth_user.dart';
import '../../../../providers/auth_provider.dart';

class ClassificaTotale extends StatelessWidget {
  const ClassificaTotale({Key? key, required this.dailyRanking, required this.weeklyRanking}) : super(key: key);

  final List<User> dailyRanking;
  final List<User> weeklyRanking;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    AuthUser authUser = authProvider.authUser!;

    dailyRanking.sort((a, b) => b.steps.compareTo(a.steps));
    weeklyRanking.sort((a, b) => b.steps.compareTo(a.steps));

    List<User> userList = dailyRanking.isEmpty ? weeklyRanking : dailyRanking;

    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        itemCount: userList.length,
        separatorBuilder: (context, index) => const Divider(thickness: 1),
        itemBuilder: (context, index) {
          int position = index + 1;
          final user = userList[index];
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
                              ?Colors.brown[400]
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
                                  : position == 3
                                    ?Colors.white
                                    : Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(authUser.imageUrl),
                  ),
                ],
              ),
            ),
            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Passi effettuati: ${user.steps}'),
          );
        },
      ),
    );
  }
}

class User {
  final String name;
  final int steps;

  User(this.name, this.steps);
}
