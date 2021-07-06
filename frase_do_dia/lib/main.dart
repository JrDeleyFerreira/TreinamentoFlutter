import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: FraseDoDia(),
      debugShowCheckedModeBanner: false,
    ));

class FraseDoDia extends StatefulWidget {
  FraseDoDia({Key? key}) : super(key: key);

  @override
  _FraseDoDiaState createState() => _FraseDoDiaState();
}

/// DICA -> Sempre utilize um decoration, colocando uma borda no body:, para que possa avaliar
/// se a montagem da tela está ficando responsiva
class _FraseDoDiaState extends State<FraseDoDia> {
  var _frases = [
    'Minha primera aplicação em Flutter!',
    'Aqui o estudo será priorizado sempre!',
    'Estamos sempre de olho nas novidades!',
    'Tecnologias do presente que impulsionarão o futuro!',
    'CR7 é o melhor jogador europeu da hstória'
  ];

  var _fraseInicial = 'Clique aqui para gerar uma nova frase!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frases do Dia'),
        backgroundColor: Colors.green.shade400,
      ),
      body: Container(
        padding: EdgeInsets.all(16), // Espaçamento dos componentes até a borda
        width: double.infinity, // Ocupa todo o espaço da tela
        child: Column(
          // Alinhamentos vertical e de eixo:
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('resources/logo.png'),
            Text(
              _fraseInicial,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
            ),
            ElevatedButton(
              child: Text(
                'Nova Frase',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: gerarFrase,
            )
          ],
        ),
      ),
    );
  }

  void gerarFrase() {
    var indiceFrase = Random().nextInt(_frases.length);
    setState(() {
      _fraseInicial = _frases[indiceFrase];
    });
  }
}
