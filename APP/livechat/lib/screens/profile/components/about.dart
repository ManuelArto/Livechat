
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Informazioni sull\'app',
        style: TextStyle(fontSize: 25),
      ),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Benvenuto nella nostra app di messaggistica e social networking!',
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 16),
          Text(
            'Caratteristiche principali:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          SizedBox(height: 6),
          Text(
            '- Scambio di messaggi e richieste di amicizia',
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 6),
          Text(
            '- Chat individuali e creazione di gruppi',
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 6),
          Text(
            '- Mappa per visualizzare la posizione in tempo reale degli amici',
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 6),
          Text(
            '- Classifica con contapassi per tenere traccia dell\'attività fisica',
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 16),
          Text(
            'Grazie per aver scelto la nostra app! Buon divertimento!',
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Version:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text('1.0.1'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Release:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text('9 luglio 2023'),
            ],
          ),
          SizedBox(height: 16),
          Row(
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
        ],
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
