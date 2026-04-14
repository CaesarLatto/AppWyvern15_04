// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class MenuPrincipalView extends StatelessWidget {
  const MenuPrincipalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
        leading: Image.asset(
          'assets/images/wyvernlogo.png',
          height: 40,
          width: 40,
          fit: BoxFit.contain,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'configuracoes') {
                Navigator.pushNamed(context, 'personalizacao');
              } else if (value == 'informacoes') {
                Navigator.pushNamed(context, 'informacoes');
              } else if (value == 'sobre') {
                Navigator.pushNamed(context, 'sobre');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'informacoes',
                child: Text('Informações'),
              ),
              const PopupMenuItem<String>(
                value: 'sobre',
                child: Text('Sobre o Projeto'),
              ),
              const PopupMenuItem<String>(
                value: 'configuracoes',
                child: Text('Configurações'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Você não possui nenhum grupo :(',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, 'addserver');
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Adicionar servidor'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'amigos');
        },
        label: const Text('Amigos'),
        icon: const Icon(Icons.people),
      ),
    );
  }
}
