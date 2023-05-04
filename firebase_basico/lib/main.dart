import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var banco = FirebaseFirestore.instance;

  /// Salvando informações passando identificador
  await banco.collection('collectionPath').doc('001').set({
    'nome': 'Wanderley',
    'idade': 31,
  });

  /// Atualizando dados no banco
  banco.collection('collectionPath').doc('FirebaseAuth.id').update({
    'nome': 'Wanderley',
    'idade': 31,
  });

  /// Salvando informações com id automático do Firebase
  DocumentReference ref = await banco.collection("noticias").add({
    'nome': 'Wanderley',
    'idade': 31,
  });
  print(ref.id); // Retorna id salvo

  /// Deletando informação de um id pré-definido ou previamente conhecido
  await banco.collection('collectionPath').doc('001').delete();

  /// Recuperando informações de um id pré-definido ou previamente conhecido
  var snapshot = await banco.collection('collectionPath').doc('001').get();
  var dados = snapshot.data();
  print(dados?['nome']);

  /// Recuperando todos os itens de uma tabela
  //var listagem = await banco.namedQueryGet('collectionPath');
  List<String> listaFinal = [];
  var listagem = await banco.collection('collectionPath').get();
  listagem.docs.forEach((element) => listaFinal.add(element['nome']));

  /// Cria um ouvinte que sincroniza informações automaticamente
  banco.collection('collectionPath').snapshots().listen((event) => event.docs);

  /// Aplicando filtros e Ordenação
  var selecao = await banco
      .collection('collectionPath')
      .where('idade', isGreaterThanOrEqualTo: 31)
      .where(
          (element) => element['nome'].toString().toUpperCase().contains('Mar'))
      .orderBy('nome', descending: true)
      .limit(3)
      .get();

  selecao.docs.forEach((element) {
    print(element);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var banco = FirebaseFirestore.instance;
  final _controllerStream = StreamController<QuerySnapshot>.broadcast();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: _controllerStream.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Stream<QuerySnapshot<Object?>> _adicionarListener() {
    final stream = banco
        .collection('collectionPath')
        .doc('idUsuario')
        .collection('collectionPath2')
        .snapshots();
    stream.listen((event) => _controllerStream.add(event));
    return stream;
  }

  @override
  void dispose() {
    _controllerStream.close();
    super.dispose();
  }
}
