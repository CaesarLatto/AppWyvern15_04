import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                onTap: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('É necessário estar logado para adicionar servidor.'),
                      ),
                    );
                    return;
                  }

                  final categoria = categorias[index];
                  final nome = 'Servidor de $categoria';
                  final docRef = FirebaseFirestore.instance.collection('servidores').doc();
                  final categoriaRef = FirebaseFirestore.instance.collection('categorias').doc(categoria.toLowerCase());
                  // Criterio 003: Inserção de dados em 'servidores' com os campos obrigatórios e acesso do usuário logado.
                  // id (doc id), nome, nome_lowercase (para busca), categoria, criadoEm e donoId (uid do usuário)
                  final data = {
                    'id': docRef.id,
                    'nome': nome,
                    'nome_lowercase': nome.toLowerCase(),
                    'categoria': categoria,
                    'criadoEm': FieldValue.serverTimestamp(),
                    'donoId': user.uid,
                  };
                  final categoriaData = {
                    'nome': categoria,
                    'nome_lowercase': categoria.toLowerCase(),
                    'donoId': user.uid,
                    'criadoEm': FieldValue.serverTimestamp(),
                    'qtdServidores': FieldValue.increment(1),
                  };

                  try {
                    await docRef.set(data);
                    await categoriaRef.set(categoriaData, SetOptions(merge: true));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Servidor "$categoria" salvo com sucesso.'),
                      ),
                    );
                  } catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao salvar servidor: ${error.toString()}'),
                      ),
                    );
                  }
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
