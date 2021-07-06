import 'package:flutter/material.dart';

class EntradaCheckBox extends StatefulWidget {
  EntradaCheckBox({Key? key}) : super(key: key);

  @override
  _EntradaCheckBoxState createState() => _EntradaCheckBoxState();
}

class _EntradaCheckBoxState extends State<EntradaCheckBox> {
  var _valorInicial = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seleção CheckBox')),
      body: Container(
          child: Column(
        children: <Widget>[
          CheckboxListTile(
            title: Text('Comida Brasileira'),
            subtitle: Text('A melhor comida do mundo!'),
            value: _valorInicial,
            onChanged: (bool? novoEstado) {
              setState(() {
                _valorInicial = novoEstado!;
              });
            },
          ),
        ],
      )),
    );
  }
}
