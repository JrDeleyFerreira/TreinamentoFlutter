import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_project_api/model/Video.dart';
import '../Api.dart';

class Inicio extends StatefulWidget {
  final String pesquisa;
  Inicio(this.pesquisa);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: _listarVideos(widget.pesquisa),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  List<Video>? videos = snapshot.data;
                  Video video = videos![index];

                  return GestureDetector(
                    onTap: () {
                      FlutterYoutube.playYoutubeVideoById(
                          apiKey: CHAVE_YOUTUBE_API,
                          videoId: video.id,
                          fullScreen: true,
                          autoPlay: true);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(video.imagemTumb!),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(video.titulo!),
                          subtitle: Text(video.canal!),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("Nenhum dado a ser exibido!"));
            }
        }
      },
    );
  }

  _listarVideos(String pesquisa) {
    API api = API();
    return api.pesquisarVideo(pesquisa);
  }
}
