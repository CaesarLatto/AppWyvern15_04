import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  
  const SobreView({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Projeto (RF005)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Sobre o Projeto',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Color(0xFF2F3136),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Projeto de Flutter com base numa empresa de comunicação por VOIP, (voice over internet protocol) com o nome de Wyvern. O app foi inspirado no app "Discord" com que possui o mesmo propósito.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            
            ),
           ],
        ),
    ),
  );
  }
}
