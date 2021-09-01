import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: TextField(
              //text, number, emailAddress, datetime
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite um valor",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(fontSize: 50, color: Colors.green),
              //enabled: false,
              //maxLength: 2,
              //maxLengthEnforced: false,
              //obscureText: true,
              /*
              onChanged: (String texto){
                print("valor digitado:" +  texto);
              },*/
              onSubmitted: (String texto) {
                print("valor digitado:" + texto);
              },
              controller: _textEditingController,
            ),
          ),
          ElevatedButton(
            child: Text("Salvar"),
            onPressed: () {
              print("valor digitado:" + _textEditingController.text);
            },
          )
        ],
      ),
    );
  }
}
