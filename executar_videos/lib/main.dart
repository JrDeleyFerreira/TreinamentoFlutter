import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    var url =
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) => setState(() {
            // _controller.play();
          }));

    _controller = VideoPlayerController.asset('assets/videos/exemplo.mp4')
      ..setLooping(true)
      ..initialize().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Text('Pressione Play'),
      ),
      floatingActionButton: FloatingActionButton(
        child: _controller.value.isPlaying
            ? Icon(Icons.pause)
            : Icon(Icons.play_arrow),
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
      ),
    );
  }
}
