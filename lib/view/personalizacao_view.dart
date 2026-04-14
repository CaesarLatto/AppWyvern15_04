
// 9/04 rf005 - tela de personalização

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/iniciarlogin_controller.dart';

class PersonalizacaoView extends StatelessWidget {
  const PersonalizacaoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.instance<IniciarloginController>();
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Personalização'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Personalização do app',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Ativar notificações'),
                  value: controller.aceitar,
                  onChanged: controller.atualizarAceitar,
                  activeColor: const Color(0xFF5865F2),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    controller.aceitar
                        ? 'Notificações ativadas'
                        : 'Notificações desativadas',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5865F2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // botão ilustrativo
                  },
                  child: const Text('Alterar saída de som'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5865F2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // botão ilustrativo
                  },
                  child: const Text('Alterar microfone'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F3136),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // botão ilustrativo
                  },
                  child: const Text('Reiniciar para personalização original'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
