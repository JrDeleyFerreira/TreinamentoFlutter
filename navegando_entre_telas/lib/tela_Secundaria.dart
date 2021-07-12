import 'package:flutter/material.dart';

class TelaSecundaria extends StatefulWidget {
  TelaSecundaria({Key? key}) : super(key: key);

  @override
  _TelaSecundariaState createState() => _TelaSecundariaState();
}

class _TelaSecundariaState extends State<TelaSecundaria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Secundária'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text('Segunda Tela!'),
          ],
        ),
      ),
    );
  }
}
