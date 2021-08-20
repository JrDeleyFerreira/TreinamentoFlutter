import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'helper/AnotacoesHelper.dart';
import 'model/Anotacao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();
  var _db = AnotacoesHelper();
  List<Anotacao> _listaAnotacoes = [];

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Anotações'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listaAnotacoes.length,
              itemBuilder: (context, index) {
                final item = _listaAnotacoes[index];
                return Card(
                  child: ListTile(
                    title: Text(item.titulo),
                    subtitle:
                        Text('${_formatDate(item.data)} - ${item.descricao}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _exibirTelaCadastro(nota: item);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _removerAnotacao(item.id!);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            _exibirTelaCadastro();
          }),
    );
  }

  _exibirTelaCadastro({Anotacao? nota}) {
    var textoSalvarAlterar = '';

    if (nota != null) {
      _tituloController.text = nota.titulo;
      _descricaoController.text = nota.descricao;
      textoSalvarAlterar = 'Modificar';
    } else {
      _tituloController.text = '';
      _descricaoController.text = '';
      textoSalvarAlterar = 'Adicionar';
    }

    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('$textoSalvarAlterar Anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Título:',
                    hintText: 'Digite um título...',
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                    labelText: 'Descrição::',
                    hintText: 'Digite uma descrição...',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    _salvarAlterarAnotacao(nota: nota);
                    Navigator.pop(context);
                  },
                  child: Text(textoSalvarAlterar)),
            ],
          ),
        );
      },
    );
  }

  _salvarAlterarAnotacao({Anotacao? nota}) async {
    var titulo = _tituloController.text;
    var descricao = _descricaoController.text;

    if (nota == null) {
      Anotacao anotacao = Anotacao(
          titulo: titulo,
          descricao: descricao,
          data: DateTime.now().toString());
      await _db.salvarAnotacao(anotacao);
    } else {
      nota.titulo = titulo;
      nota.descricao = descricao;
      nota.data = DateTime.now().toString();
      await _db.atualizarNotas(nota);
    }

    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacoes();
  }

  _recuperarAnotacoes() async {
    var anotacoesRecuperadas = await _db.recuperarAnotacoesBanco();
    List<Anotacao>? listaTemporaria = [];

    for (var item in anotacoesRecuperadas) {
      Anotacao nota = Anotacao.fromMap(item);
      listaTemporaria.add(nota);
    }

    setState(() {
      _listaAnotacoes = listaTemporaria!;
    });
    listaTemporaria = null;
  }

  _formatDate(String data) {
    initializeDateFormatting('pt_BR');
    //var mascaraData = DateFormat('d / M / y');
    var mascaraData = DateFormat.yMMMMd('pt_BR');
    return mascaraData.format(DateTime.parse(data));
  }

  _removerAnotacao(int idNota) async {
    await _db.removerNota(idNota);
  }
}
