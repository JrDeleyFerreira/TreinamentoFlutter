import 'package:flutter/material.dart';
import 'package:youtube_project_api/controller/CustomSearchDelegate.dart';
import 'view/Biblioteca.dart';
import 'view/EmAlta.dart';
import 'view/Inicio.dart';
import 'view/Inscricao.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _indicePagina = 0;
  var _resultPesquisa = "";

  @override
  Widget build(BuildContext context) {
    List telas = [Inicio(_resultPesquisa), EmAlta(), Inscricao(), Biblioteca()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('resources/youtube.png', width: 98, height: 22),
        iconTheme: IconThemeData(color: Colors.grey, opacity: 0.2),
        actions: [
          //IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
          //IconButton(onPressed: () {}, icon: Icon(Icons.account_circle)),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var res = await showSearch(
                  context: context, delegate: CustomSearchDelegate());
              setState(() {
                _resultPesquisa = res!;
              });
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: telas[_indicePagina],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.redAccent,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: 'Em Alta'),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions), label: 'Inscrições'),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder), label: 'Biblioteca'),
        ],
        onTap: (indice) {
          setState(() {
            _indicePagina = indice;
          });
        },
      ),
    );
  }
}
