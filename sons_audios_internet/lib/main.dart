import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var audioPlayer = AudioPlayer();
  final playerCache = AudioCache(prefix: 'audios/');
  var primeiraExecucao = true;
  var volume = 0.5;

  _executarSomUrl() async {
    var url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3';
    await audioPlayer.play(AssetSource(url));
  }

  //static var playerCache = AudioCache();
  _executarSomAudioLocal() async {
    audioPlayer.setVolume(volume);

    if (primeiraExecucao) {
      await audioPlayer.play(AssetSource('musica.mp3'));
      primeiraExecucao = false;
    } else {
      audioPlayer.resume();
    }
  }

  _pausarAudio() async => await audioPlayer.pause();
  _pararAudio() async => await audioPlayer.stop();

  @override
  Widget build(BuildContext context) {
    //_executarSomUrl();
    return Scaffold(
      appBar: AppBar(title: Text('Executando sons')),
      body: Column(
        children: [
          Slider(
            value: volume,
            min: 0,
            max: 1,
            onChanged: (novoVolume) {
              setState(() {
                volume = novoVolume;
              });
              audioPlayer.setVolume(novoVolume);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  child: Image.asset('assets/imagens/executar.png'),
                  onTap: () {
                    _executarSomAudioLocal();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  child: Image.asset('assets/imagens/pausar.png'),
                  onTap: () {
                    _pausarAudio();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  child: Image.asset('assets/imagens/parar.png'),
                  onTap: () {
                    _pararAudio();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
