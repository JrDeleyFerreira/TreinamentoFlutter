import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as My_http;
import 'dart:async';

import 'Post.dart';

void main() => runApp(MaterialApp(home: HomeFuture()));

class HomeFuture extends StatefulWidget {
  HomeFuture({Key? key}) : super(key: key);

  @override
  _HomeFutureState createState() => _HomeFutureState();
}

class _HomeFutureState extends State<HomeFuture> {
  /* Future<Map> _recuperPrecoBitCoin() async {
    Uri url = Uri.parse('https://blockchain.info.ticker');
    My_http.Response response = await My_http.get(url);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperPrecoBitCoin(),
      builder: (context, snapshot) {
        String resultado;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            resultado = 'Carregando...';
            break;
          case ConnectionState.done:
            if (snapshot.hasError)
              resultado = 'Erro ao carregar os dados.';
            else {
              var valor = snapshot.data!['BRL']['buy'];
              resultado = 'Preço do BitCoin: ${valor.toString()}';
            }
            break;
        }

        return Center(child: Text(resultado));
      },
    );
  } */

  String _urlBase = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> _recuperaListaPostagens() async {
    My_http.Response response =
        await My_http.get(Uri.parse(_urlBase + '/posts'));
    var dadosJson = jsonDecode(response.body);

    List<Post> postagens = [];

    for (var item in dadosJson) {
      Post p = Post(
          userId: item.userId, id: item.id, title: item.title, body: item.body);
      postagens.add(p);
    }
    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas da Web'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperaListaPostagens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(
                    child: Text('Lista: Ocorreu um erro ao carregar!'));
              else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    List<Post>? lista = snapshot.data;
                    Post post = lista![index];

                    return ListTile(
                      title: Text(post.userId.toString()),
                      subtitle: Text(post.title),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
