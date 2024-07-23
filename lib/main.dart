import 'package:flutter/material.dart';
import 'package:graph_ql/config/graphql_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'ui/screens/home_screen.dart';

void main(List<String> args) {
  final client = GraphqlConfig.initializaClient();

  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  const MyApp({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const CacheProvider(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
  }
}
