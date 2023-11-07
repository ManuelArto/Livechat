import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:livechat/screens/chat/components/trusted/news_entry_card.dart';
import 'package:livechat/services/graphql_service.dart';

class NewsEntriesList extends StatelessWidget {
  const NewsEntriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLService.instance.graphqlClient,
      child: Query(
        options: QueryOptions(
          document: gql(query),
          variables: const <String, dynamic>{"variableName": "value"},
        ),
        builder: (result, {fetchMore, refetch}) {
          return result.isLoading
              ? const Center(child: CircularProgressIndicator())
              : result.data == null
                  ? const Text("No News found!")
                  : _buildNewsEntriesCard(result.data!['newsEntries']);
        },
      ),
    );
  }

  Widget _buildNewsEntriesCard(List newsEntries) {
    return ListView.builder(
      itemCount: newsEntries.length,
      itemBuilder: (context, index) {
        debugPrint(newsEntries[index].toString());
        return NewsEntryCard(newsEntries[index]);
      },
    );
  }

  final String query = """{
      newsEntries(orderBy: blockTimestamp, orderDirection: asc) {
        id
        sender
        title
        ipfsCid
        chatName
        isForwaded
        parentNews {
          id
          title
        }
        evaluation {
          id
          status
        }
        forwarded {
          id
          title
        }
        blockTimestamp
        blockNumber
        transactionHash
      }
    }""";
}
