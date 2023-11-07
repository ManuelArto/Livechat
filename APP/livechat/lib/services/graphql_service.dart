import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants.dart';

class GraphQLService {
  // SINGLETON
  static GraphQLService? _instance;
  static GraphQLService get instance {
    _instance ??= GraphQLService._();
    return _instance!;
  }

  GraphQLService._();

  final ValueNotifier<GraphQLClient> _graphqlClient = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: HttpLink(GRAPHQL_URL),
      cache: GraphQLCache(),
    ),
  );

  get graphqlClient => _graphqlClient;
}
