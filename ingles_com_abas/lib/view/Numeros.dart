import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Numeros extends StatefulWidget {
  Numeros({Key? key}) : super(key: key);

  @override
  _NumerosState createState() => _NumerosState();
}

class _NumerosState extends State<Numeros> {
  final _audioCache = AudioCache(prefix: 'audios/');

  _executarSom(String nomeSom) {
    _audioCache.play(nomeSom + '.mp3');
  }

  @override
  void initState() {
    super.initState();
    _audioCache.loadAll([
      '1.mp3',
      '2.mp3',
      '3.mp3',
      '4.mp3',
      '5.mp3',
      '6.mp3',
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      childAspectRatio: MediaQuery.of(context).size.aspectRatio * 2,
      children: [
        GestureDetector(
          child: Image.asset('assets/imagens/1.png'),
          onTap: () {
            _executarSom('1');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/2.png'),
          onTap: () {
            _executarSom('2');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/3.png'),
          onTap: () {
            _executarSom('3');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/4.png'),
          onTap: () {
            _executarSom('4');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/5.png'),
          onTap: () {
            _executarSom('5');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/6.png'),
          onTap: () {
            _executarSom('6');
          },
        ),
      ],
    );
  }
}
