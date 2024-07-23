import 'package:flutter/material.dart';
import 'package:graph_ql/core/constants/graphql_mutations.dart';
import 'package:graph_ql/core/constants/prahql_queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _addProduct(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(addProduct),
          variables: const {
            'title': "Salom test",
            'price': 10.0,
            'description': "test desc",
            'categoryId': 1,
            'images': [
              "https://avatars.mds.yandex.net/i?id=1e433a61e14ac53896ba9dd8fb60c3f1997bdf6d6e29ffc1-10534377-images-thumbs&n=13"
            ],
          },
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ma'lumotlar muvaffaqiyatli qo'shildi"),
        ),
      );
      print(result);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
        ),
      );
    }
  }

  void _editProduct(BuildContext context, String productId) async {
    final client = GraphQLProvider.of(context).value;

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(updateProduct),
          variables: {
            'id': productId,
            'title': "O'zgargan malumot",
            'price': 123.0,
            'description': "test desc",
            'categoryId':
                1, // Ensure this ID matches your schema's expected ID type
          },
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ma'lumotlar muvaffaqiyatli yangilandi"),
        ),
      );
      print(result);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
        ),
      );
    }
  }

  // void dele
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home screen"),
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          document: gql(fetchProducts),
        ),
        builder: (QueryResult result,
            {FetchMore? fetchMore, VoidCallback? refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List products = result.data!['products'];
          if (products.isEmpty) {
            return const Center(
              child: Text("No products found"),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product['title']),
                subtitle: Text('${product['description']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        // print(product['id']);

                        final client = GraphQLProvider.of(context).value;
                        try {
                          final result = await client.mutate(
                            MutationOptions(
                              document: gql(deleteProduct),
                              variables: {
                                'id': product['id'],
                              },
                            ),
                          );

                          if (result.hasException) {
                            throw result.exception!;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Ma'lumotlar muvaffaqiyatli yangilandi"),
                            ),
                          );
                          print(result);
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: ${e.toString()}"),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.teal,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _editProduct(context, product['id']);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addProduct(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
