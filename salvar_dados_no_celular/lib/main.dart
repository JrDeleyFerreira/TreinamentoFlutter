import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _controllerCampo = TextEditingController();
  String _textoDigitado = 'Nada Digitado';

  _salvarDado() async {
    String valorDigitado = _controllerCampo.text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('key', valorDigitado);
  }

  _recuperarDado() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textoDigitado = prefs.getString('key') ?? 'Sem valor!';
    });
  }

  _remover() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('key');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manipulando Dados no Cel.')),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              _textoDigitado,
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Digite algo:'),
              controller: _controllerCampo,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _salvarDado,
                  child: Text(
                    'Salvar',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: _recuperarDado,
                  child: Text(
                    'Recuperar',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                ),
                ElevatedButton(
                  onPressed: _remover,
                  child: Text(
                    'Remover',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
