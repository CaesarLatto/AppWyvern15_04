import 'package:flutter/material.dart';
import 'perfamigo_view.dart';

class AmigosView extends StatelessWidget {
  const AmigosView({super.key});

  @override
  Widget build(BuildContext context) {
    final amigos = List<String>.generate(13, (index) => 'fulano${index + 1}');
 // list generate é uma função que gera uma lista de strings, com o nome dos fulano,
      // usando o index para criar nomes diferentes, e o +1 é pra começar do 1, e não do 0 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amigos'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: amigos.length,
        itemBuilder: (context, index) {
          final nomeAmigo = amigos[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfAmigoView(nomeAmigo: nomeAmigo),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F3136),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  nomeAmigo,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
