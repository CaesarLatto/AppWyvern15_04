import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PesquisaServidorView extends StatefulWidget {
  const PesquisaServidorView({super.key});

  @override
  State<PesquisaServidorView> createState() => _PesquisaServidorViewState();
}

class _PesquisaServidorViewState extends State<PesquisaServidorView> {
  static const _orderOptions = ['Ordem Alfabética', 'Mais Recentes'];

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  String _selectedOrder = _orderOptions.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _servidoresStream() {
    final lowerTerm = _searchTerm.toLowerCase();
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('servidores');

    if (lowerTerm.isNotEmpty) {
      query = query
          .where('nome_lowercase', isGreaterThanOrEqualTo: lowerTerm)
          .where('nome_lowercase', isLessThan: '$lowerTerm\uf8ff');
    }

    if (_selectedOrder == 'Ordem Alfabética') {
      query = query.orderBy('nome_lowercase');
    } else {
      query = query.orderBy('criadoEm', descending: true);
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36393E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F3136),
        title: const Text('Pesquisar Servidor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Buscar servidor por nome',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2F3136),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      _searchTerm = _searchController.text.trim();
                    });
                  },
                ),
              ),
              onSubmitted: (_) {
                setState(() {
                  _searchTerm = _searchController.text.trim();
                });
              },
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2F3136),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedOrder,
                  dropdownColor: const Color(0xFF2F3136),
                  style: const TextStyle(color: Colors.white),
                  items: _orderOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedOrder = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _servidoresStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar servidores: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  final servidores = snapshot.data?.docs ?? [];
                  if (servidores.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum servidor encontrado.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: servidores.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = servidores[index].data();
                      final nome = data['nome'] as String? ?? 'Servidor sem nome';
                      final categoria = data['categoria'] as String? ?? 'Categoria desconhecida';
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F3136),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          title: Text(
                            nome,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            categoria,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
