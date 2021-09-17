import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'mapa.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _streamController = StreamController<QuerySnapshot>.broadcast();
  final FirebaseFirestore _banco = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _listenerDeViagens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(title: const Text('Minhas Viagens')),

      // ActionButton
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xff0066cc),
        onPressed: () {
          _adicionarLocal();
        },
      ),

      // Body
      body: StreamBuilder<QuerySnapshot>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.done:
                var querySnapshot = snapshot.data;
                var viagensDocSnapshot = querySnapshot?.docs.toList();

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: viagensDocSnapshot?.length,
                        itemBuilder: (context, index) {
                          var item = viagensDocSnapshot?[index];

                          return GestureDetector(
                            onTap: () {
                              _abrirMapa(item?.id);
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(item?['titulo']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _excluirViagem(item?.id);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
            }
          }),
    );
  }

  _abrirMapa(String? idViagem) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Mapa(idViagem: idViagem),
      ));

  _excluirViagem(String? idViagem) async {
    await _banco.collection('viagens').doc(idViagem).delete();
  }

  _adicionarLocal() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Mapa()),
      );

  _listenerDeViagens() async {
    final stream = _banco.collection('viagens').snapshots();
    stream.listen((dados) => _streamController.add(dados));
  }
}
