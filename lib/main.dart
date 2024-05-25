import 'package:cat/cat.dart';
import 'package:flutter/material.dart';

//INTEGRANTES
//JOSÉ FRANCISCO ORTIZ
//JORDY PALACIOS BROWN

void main() {
  runApp(const CatGame());
}

class CatGame extends StatelessWidget {
  const CatGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego del Gato',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF021013),
      ),
      home: const Cat(),
      debugShowCheckedModeBanner: false,
    );
  }
}
