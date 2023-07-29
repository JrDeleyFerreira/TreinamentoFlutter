import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Animais extends StatefulWidget {
  Animais({Key? key}) : super(key: key);

  @override
  _AnimaisState createState() => _AnimaisState();
}

class _AnimaisState extends State<Animais> {
  final _audioPlayer = AudioPlayer();
  var _cachePlayer = AudioCache();

  _executarSom(String nomeSom) {
    _cachePlayer = (_audioPlayer.audioCache.prefix = 'audios/') as AudioCache;
    _audioPlayer.play(AssetSource(nomeSom + '.mp3'));
  }

  @override
  void initState() {
    super.initState();
    _cachePlayer.loadAll([
      'cao.mp3',
      'gato.mp3',
      'leao.mp3',
      'macaco.mp3',
      'ovelha.mp3',
      'vaca.mp3',
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
          child: Image.asset('assets/imagens/cao.png'),
          onTap: () {
            _executarSom('cao');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/gato.png'),
          onTap: () {
            _executarSom('gato');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/leao.png'),
          onTap: () {
            _executarSom('leao');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/macaco.png'),
          onTap: () {
            _executarSom('macaco');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/ovelha.png'),
          onTap: () {
            _executarSom('ovelha');
          },
        ),
        GestureDetector(
          child: Image.asset('assets/imagens/vaca.png'),
          onTap: () {
            _executarSom('vaca');
          },
        ),
      ],
    );
  }
}
