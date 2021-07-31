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
  String _urlBase = 'https://jsonplaceholder.typicode.com';

  // Utilizando o GET para buscar uma lista de Postagens
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

  /// *************************************************************************
  /// Utilizando o POST para criar uma Postagem:

  _criaPost() async {
    var obj = Post(
        userId: 120, id: null, title: 'Título', body: 'Corpo da postagem.');
    var corpoMsg = jsonEncode({obj.toJson()});

    My_http.Response response = await My_http.post(
      Uri.parse(_urlBase + '/posts'),
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: corpoMsg,
    );

    print(response.statusCode);
    print(response.body);
  }

  /// *************************************************************************
  /// Utilizando o POST para criar uma Postagem:
  _alteraPatch() async {
    var corpoMsg = jsonEncode({
      'userId': 120,
      'body': 'Alterando a mensagem do corpo da postagem com PATCH'
    });
    My_http.Response response = await My_http.patch(
      Uri.parse(_urlBase + '/posts/2'),
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: corpoMsg,
    );
    print(response.statusCode);
    print(response.body);
  }

  /// *************************************************************************
  /// Utilizando o DELETE
  _deletaPostagem() async =>
      await My_http.delete(Uri.parse(_urlBase + '/posts/15'));

  /// *************************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas da Web'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(onPressed: _criaPost, child: Text('Salvar')),
                ElevatedButton(
                    onPressed: _alteraPatch, child: Text('Atualizar')),
                ElevatedButton(
                    onPressed: _deletaPostagem, child: Text('Remover')),
              ],
            ),
            Expanded(
              child: _montaListaPostagens(),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Post>> _montaListaPostagens() {
    return FutureBuilder<List<Post>>(
      future: _recuperaListaPostagens(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError)
              return Center(child: Text('Lista: Ocorreu um erro ao carregar!'));
            else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  List<Post>? lista = snapshot.data;
                  Post post = lista![index];

                  return ListTile(
                    title: Text(post.userId.toString()),
                    subtitle: Text(post.title!),
                  );
                },
              );
            }
        }
      },
    );
  }
}
