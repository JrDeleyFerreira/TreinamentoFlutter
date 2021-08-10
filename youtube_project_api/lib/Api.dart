import 'package:http/http.dart' as My_http;
import 'dart:convert';
import 'model/Video.dart';

/// Essa chave é apenas ilustrativa.
/// Para obter uma chave real, deve-se ativar a API do Youtube
const CHAVE_YOUTUBE_API = "AIzaSyBrQSLDqhY4II3lRaYHkCEW5zfNOQtsGZc";

/// Obtida ao encontrar o canal desejado, abrir um vídeo e acessar novamente o
/// canal usando a navegação abaixo do vídeo
const ID_CANAL = "UCVHFbqXqoYvEWM1Ddxl0QDg";

/// URL encontrada na documentação da API
const URL_BASE = "https://www.googleapis.com/youtube/v3/";

class API {
  Future<List<Video>?> pesquisarVideo(String pesquisa) async {
    My_http.Response response = await My_http.get(Uri.parse(URL_BASE +
        'search'
            '?part=snippet'
            '&type=video'
            '&maxResults=20'
            '&order=date'
            '&key=$CHAVE_YOUTUBE_API'
            '&channelId=$ID_CANAL'
            '&q=$pesquisa'));

    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = jsonDecode(response.body);

      List<Video> videos = dadosJson['itens'].map<Video>((map) {
        return Video.fromMap(map);
      }).toList();

      return videos;
    }
  }
}
