import 'package:flutter/material.dart';

class NewsEntryCard extends StatelessWidget {
  final Map<String, dynamic> newsEntry;

  const NewsEntryCard(this.newsEntry, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Id: ${newsEntry['id']}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Title: ${newsEntry['title']}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'IPFS CID: ${newsEntry['ipfsCid']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Chat Name: ${newsEntry['chatName']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Is Forwarded: ${newsEntry['isForwaded']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Evaluation Status: ${newsEntry['evaluation']['status']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Divider(),
              if (newsEntry['parentNews'] != null)
                Text(
                  'Parent News: ${newsEntry['parentNews']['id']} - ${newsEntry['parentNews']['title']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (newsEntry["forwarded"] != null)
                Text(
                  'Forwarded News: ${(newsEntry['forwarded'] as List).map((e) => e["id"]).join("-")}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const Divider(),
              Text(
                'Block Timestamp: ${newsEntry['blockTimestamp']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Block Number: ${newsEntry['blockNumber']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Transaction Hash: ${newsEntry['transactionHash']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
