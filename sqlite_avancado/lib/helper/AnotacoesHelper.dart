import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_avancado/model/Anotacao.dart';

const nomeTabela = 'anotacao';

class AnotacoesHelper {
  static final AnotacoesHelper _anotacoesHelper = AnotacoesHelper._internal();
  Database? _db;

  factory AnotacoesHelper() {
    return _anotacoesHelper;
  }
  AnotacoesHelper._internal();

  Future<Database> get db async => _db ?? await inicializarDB();

  inicializarDB() async {
    final caminhoBanco = await getDatabasesPath();
    final localBanco = join(caminhoBanco, 'banco_anotacoes.db');
    return await openDatabase(localBanco, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int versao) async {
    var sql = 'CREATE TABLE $nomeTabela ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'titulo VARCHAR, '
        'descricao TEXT, '
        'data DATETIME)';
    await db.execute(sql);
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    return await bancoDados.insert(nomeTabela, anotacao.toMap());
  }

  recuperarAnotacoesBanco() async {
    var banco = await db;
    var sql = 'SELECT * FROM $nomeTabela ORDER BY data DESC';
    return await banco.rawQuery(sql);
  }

  Future<int> atualizarNotas(Anotacao anotacao) async {
    var banco = await db;
    return await banco.update(nomeTabela, anotacao.toMap(),
        where: 'id = ?', whereArgs: [anotacao.id]);
  }

  Future<int> removerNota(int idNota) async {
    var banco = await db;
    return await banco.delete(nomeTabela, where: 'id = ?', whereArgs: [idNota]);
  }
}
