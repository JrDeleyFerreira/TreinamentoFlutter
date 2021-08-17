import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];
  late Map<String, dynamic> _ultimaTarefaRemovida;
  var _controllerTarefa = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.purple,
      ),

// ************** DIVISÓRIA **************

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Adicionar tarefa'),
                content: TextField(
                  decoration: InputDecoration(labelText: 'Digite sua tarefa:'),
                  onChanged: (text) {},
                  controller: _controllerTarefa,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      _salvarTarefa();
                      Navigator.pop(context);
                    },
                    child: Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
      ),

// ************** DIVISÓRIA **************

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listaTarefas.length,
              itemBuilder: criaListagemTarefas,
            ),
          )
        ],
      ),
    );
  }

// ************** DIVISÓRIA **************

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/dados.json');
  }

  _salvarTarefa() {
    var textoDigitado = _controllerTarefa.text;

    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = textoDigitado;
    tarefa['realizada'] = false;

    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = '';
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();
    var dados = jsonEncode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  Widget criaListagemTarefas(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Recuperar item a ser excluído
        _ultimaTarefaRemovida = _listaTarefas[index];

        _listaTarefas.removeAt(index);
        _salvarArquivo();

        // SnackBar
        final snackbar = SnackBar(
          content: Text('Tarefa Removida'),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              setState(() {
                _listaTarefas.insert(index, _ultimaTarefaRemovida);
              });
              _salvarArquivo();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
      background: Container(
        padding: EdgeInsets.all(16),
        color: Colors.red,
        child: Row(
          children: [Icon(Icons.delete, color: Colors.white)],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
      child: CheckboxListTile(
          title: Text(_listaTarefas[index]['titulo']),
          value: _listaTarefas[index]['realizada'],
          onChanged: (bool? novoEstado) {
            setState(() {
              _listaTarefas[index]['realizada'] = novoEstado!;
            });
            _salvarArquivo();
          }),
    );
  }
}
