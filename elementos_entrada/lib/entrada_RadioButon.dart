import 'package:flutter/material.dart';

class EntradaRadioButton extends StatefulWidget {
  EntradaRadioButton({Key? key}) : super(key: key);

  @override
  _EntradaRadioButtonState createState() => _EntradaRadioButtonState();
}

class _EntradaRadioButtonState extends State<EntradaRadioButton> {
  var _escolhaSexo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seleção CheckBox')),
      body: Container(
        child: Column(
          children: <Widget>[
            RadioListTile(
              title: Text('MASCULINO'),
              subtitle: Text('Nascido homem!'),
              value: 'm',
              groupValue: _escolhaSexo,
              onChanged: (String? escolha) {
                setState(() {
                  _escolhaSexo = escolha!;
                });
              },
            ),
            RadioListTile(
              title: Text('FEMININO'),
              subtitle: Text('Nascida mulher!'),
              value: 'f',
              groupValue: _escolhaSexo,
              onChanged: (String? escolha) {
                setState(() {
                  _escolhaSexo = escolha!;
                });
              },
            ),
            ElevatedButton(
              child: Text('Escolha Sexo'),
              onPressed: () {
                print('Escolha seox: $_escolhaSexo');
              },
            ),
          ],
        ),
      ),
    );
  }
}
