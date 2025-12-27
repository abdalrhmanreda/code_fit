import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlHelper {
  GraphqlHelper._(); // private constructor

  static final HttpLink _httpLink = HttpLink('https://graphql.anilist.co');

  static final Link _link = _httpLink;

  static final ValueNotifier<GraphQLClient> client =
      ValueNotifier<GraphQLClient>(
        GraphQLClient(
          link: _link,
          cache: GraphQLCache(store: HiveStore()),
        ),
      );
}
