import 'dart:math';
import 'package:flutter/material.dart';

class Jogo extends StatefulWidget {
  const Jogo({Key? key}) : super(key: key);

  @override
  _JogoState createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  var _imagemApp = AssetImage('resources/padrao.png');
  var _fraseJogo = 'Escolha do Jogador:';

  void _opcaoSelecionada(String escolhaUsuario) {
    var opcoesJogador = ['pedra', 'papel', 'tesoura'];
    var numeroApp = Random().nextInt(3);
    var escolhaApp = opcoesJogador[numeroApp];

    // Dada a seleção randômica para o App, setar a imagem da sua escolha
    switch (escolhaApp) {
      case 'pedra':
        setState(() {
          _imagemApp = AssetImage('resources/pedra.png');
        });
        break;
      case 'papel':
        setState(() {
          _imagemApp = AssetImage('resources/papel.png');
        });
        break;
      case 'tesoura':
        setState(() {
          _imagemApp = AssetImage('resources/tesoura.png');
        });
        break;
    }

    // Comparação da escolha do Aplicativo e do Jogador, coparadas:
    if ((escolhaUsuario == 'pedra' && escolhaApp == 'tesoura') ||
        (escolhaUsuario == 'papel' && escolhaApp == 'pedra') ||
        (escolhaUsuario == 'tesoura' && escolhaApp == 'papel')) {
      setState(() {
        _fraseJogo = 'Parabéns, você ganhou :)!!';
      });
    } else if ((escolhaApp == 'pedra' && escolhaUsuario == 'tesoura') ||
        (escolhaApp == 'papel' && escolhaUsuario == 'pedra') ||
        (escolhaApp == 'tesoura' && escolhaUsuario == 'papel')) {
      setState(() {
        _fraseJogo = 'Você perdeu! Tente novamente :(';
      });
    } else {
      setState(() {
        _fraseJogo = 'Empate! Tente novamente :/';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jo-Ken-Po'),
        backgroundColor: Colors.grey.shade400,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              'Escolha da Máquina:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Image(image: _imagemApp),
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              _fraseJogo,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _opcaoSelecionada('pedra'),
                child: Image.asset('resources/pedra.png', height: 100),
              ),
              GestureDetector(
                onTap: () => _opcaoSelecionada('papel'),
                child: Image.asset('resources/papel.png', height: 100),
              ),
              GestureDetector(
                onTap: () => _opcaoSelecionada('tesoura'),
                child: Image.asset('resources/tesoura.png', height: 100),
              )
            ],
          ),
        ],
      ),
    );
  }
}
