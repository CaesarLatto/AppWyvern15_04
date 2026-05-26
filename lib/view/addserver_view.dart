import 'package:flutter/material.dart';
// 14/04 rf005 - tela de addicionar servidor
class AddServerView extends StatelessWidget {
  const AddServerView({super.key});

  static const List<String> categorias = [ // lista de categorias 
                       //para os servidores que estão no gridview
    'Games',
    'Animes',
    'Conversa',
    'política',
    'estudos',
    'Amizade',
    'RPG',
    'comunidade',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( // rn é a estrutura básica de uma tela, tem appbar, body, etc
      appBar: AppBar(
        title: const Text('Adicionar servidor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(   // Usando GridView para exibir as categorias em grade
          itemCount: categorias.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12, // Espaçamento vertical entre os itens
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            return Card(
              color: const Color(0xFF2F3136),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),// assim que faz borda redonda
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // botão ilustrativo, não faz nada
                },
                child: Center(
                  child: Text(
                    categorias[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
