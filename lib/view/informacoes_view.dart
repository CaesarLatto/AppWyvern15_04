import 'package:flutter/material.dart';
// 12/04 rf005 - tela de info adicional

import 'package:get_it/get_it.dart';
import '../controller/iniciarlogin_controller.dart';

class InformacoesView extends StatelessWidget {
  const InformacoesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.instance<IniciarloginController>();
    final nome = controller.usuarioLogadoNome.isEmpty
        ? 'Nome do usuário'
        : controller.usuarioLogadoNome;
    final email = controller.usuarioLogadoEmail.isEmpty
        ? 'email@exemplo.com'
        : controller.usuarioLogadoEmail;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o usuário'),
        backgroundColor: const Color(0xFF2F3136),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.person,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              nome,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Informações do perfil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF40444B),
              child: ListTile(
                title: const Text(
                  'Nome',
                  style: TextStyle(color: Colors.white70),
                ),
                subtitle: Text(
                  nome,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF40444B),
              child: ListTile(
                title: const Text(
                  'E-mail',
                  style: TextStyle(color: Colors.white70),
                ),
                subtitle: Text(
                  email,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // botão ilustrativo
              },
              child: const Text('Trocar senha'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED4245),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // botão ilustrativo
              },
              child: const Text('Deletar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
