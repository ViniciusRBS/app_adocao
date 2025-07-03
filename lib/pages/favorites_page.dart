import 'package:flutter/material.dart';

class MockFavoritesPage extends StatelessWidget {
  const MockFavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritos = [
      {'nome': 'Luna', 'descricao': 'Cachorra brincalhona'},
      {'nome': 'Milo', 'descricao': 'Gato tranquilo'},
    ];

    return ListView.builder(
      itemCount: favoritos.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final animal = favoritos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(animal['nome']!),
            subtitle: Text(animal['descricao']!),
          ),
        );
      },
    );
  }
}
