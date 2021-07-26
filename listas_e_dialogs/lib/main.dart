import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _lista = [];

  _carregaListaElementos() {
    _lista = [];
    for (int i = 0; i <= 10; i++) {
      Map<String, dynamic> item = Map();
      item['titulo'] = 'Título: $i ASD';
      item['descricao'] = 'Descrição: $i JKL';

      _lista.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    _carregaListaElementos();

    return Container(
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: _lista.length,
        itemBuilder: (context, indice) {
          //Map<String, dynamic> map = _lista[indice];
          return ListTile(
            //title: Text(map['titulo']),
            title: Text(_lista[indice]['titulo']),
            subtitle: Text(_lista[indice]['descricao']),
            onTap: () {
              showDialog(
                  context: context, // Contexto
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Título'), // Título
                      content: Text('Conteúdo'), // Mensagem
                      actions: [
                        TextButton(
                            onPressed: () {
                              // Implementar a ação AQUI
                              Navigator.pop(context); // Fecha a AlertDialog()
                            },
                            child: Text('SIM')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('NÃO')),
                      ],
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
