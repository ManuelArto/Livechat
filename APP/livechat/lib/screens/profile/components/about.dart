import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Informazioni sull\'app',
        style: TextStyle(fontSize: theme.textTheme.bodyLarge!.fontSize! + 5),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Benvenuto nella nostra app di messaggistica e social networking!',
              style: TextStyle(),
            ),
            const SizedBox(height: 16),
            Text(
              'Caratteristiche principali:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: theme.textTheme.bodyLarge?.fontSize),
            ),
            const SizedBox(height: 6),
            const Text(
              '- Scambio di messaggi e richieste di amicizia',
              style: TextStyle(),
            ),
            const SizedBox(height: 6),
            const Text(
              '- Chat individuali e creazione di gruppi',
              style: TextStyle(),
            ),
            const SizedBox(height: 6),
            const Text(
              '- Mappa per visualizzare la posizione in tempo reale degli amici',
              style: TextStyle(),
            ),
            const SizedBox(height: 6),
            const Text(
              '- Classifica con contapassi per tenere traccia dell\'attività fisica',
              style: TextStyle(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Grazie per aver scelto la nostra app! Buon divertimento!',
              style: TextStyle(),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text(
                  'Version:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text('1.0.1'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text(
                  'Release:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text('9 luglio 2023'),
              ],
            ),
            const SizedBox(height: 16),
            const FittedBox(
              child: Row(
                children: [
                  Text(
                    'Authors:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Manuel Arto, Andrea Napoli',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              child: const Text(
                'Chiudi',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
