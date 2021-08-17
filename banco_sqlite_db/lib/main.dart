import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//++++++++++++++++++ SEPARADOR ++++++++++++++++++
  _recuperarBancoDados() async {
    final caminhoBanco = await getDatabasesPath();
    final nomelocalBanco = join(caminhoBanco, 'bancoSqlite.db');

    var retornoBD = await openDatabase(
      nomelocalBanco,
      version: 1,
      onCreate: (db, dbRecentVersion) {
        var sql = 'CREATE TABLE usuarios ' +
            '(id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
            'nome VARCHAR NOT NULL, idade INTEGER)';
        db.execute(sql);
      },
    );
    return retornoBD;
  }

  //++++++++++++++++++ SEPARADOR ++++++++++++++++++

  _salvarDados() async {
    Map<String, dynamic> dadosUsuario = {
      'nome': 'Wanderley Ferreira',
      'idade': 31
    };
    Database bd = await _recuperarBancoDados();
    await bd.insert('usuario', dadosUsuario);

    // Caso queramos recuperar o ID do item inserido
    //var idInserido = await bd.insert('usuario', dadosUsuario);
    //print(idInserido.toString());
  }

  //++++++++++++++++++ SEPARADOR ++++++++++++++++++

  _listaTdsUsuarios() async {
    var sql = 'SELECT * FROM usuarios ';
    Database bd = await _recuperarBancoDados();
    await bd.rawQuery(sql);
    // List usuarios = await bd.rawQuery(sql);
  }

  //++++++++++++++++++ SEPARADOR ++++++++++++++++++

  _listaComArgumento(String nome, int id) async {
    Database bd = await _recuperarBancoDados();
    //List usuarios = await bd.query('table',
    await bd.query('table',
        columns: ['id', 'nome', 'idade'],
        where: 'id = ? AND nome = ?',
        whereArgs: [id, nome]);
  }

  //++++++++++++++++++ SEPARADOR ++++++++++++++++++

  _deletaUsuarios(int id) async {
    Database bd = await _recuperarBancoDados();
    await bd.delete(
      'table',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //++++++++++++++++++ SEPARADOR ++++++++++++++++++

  @override
  Widget build(BuildContext context) {
    _salvarDados();
    _listaTdsUsuarios();
    _listaComArgumento('nome', 15);
    _deletaUsuarios(21);
    return Container(
      child: null,
    );
  }
}
