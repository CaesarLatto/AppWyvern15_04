
// 14/04 rf005 - tela de perfil do amigo

import 'package:flutter/material.dart';



class PerfAmigoView extends StatelessWidget {
  final String nomeAmigo;

  const PerfAmigoView({required this.nomeAmigo, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeAmigo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              nomeAmigo,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Ligar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Enviar mensagem'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED4245),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Desfazer amizade'),
            ),
          ],
        ),
      ),
    );
  }
}
