import 'package:flutter/material.dart';

class OrientacaoTela extends StatefulWidget {
  const OrientacaoTela({Key? key}) : super(key: key);

  @override
  _OrientacaoTelaState createState() => _OrientacaoTelaState();
}

class _OrientacaoTelaState extends State<OrientacaoTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orientação')),
      body: OrientationBuilder(
        builder: (context, orientacao) {
          return GridView.count(
            crossAxisCount: orientacao == Orientation.portrait ? 2 : 3,
            children: [
              Container(),
              Container(),
              Container(),
              Container(),
              Container(),
              Container(),
            ],
          );
        },
      ),
    );
  }
}
