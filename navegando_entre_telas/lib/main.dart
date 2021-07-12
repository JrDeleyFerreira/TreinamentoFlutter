import 'package:flutter/material.dart';
import 'tela_Secundaria.dart';

void main() => runApp(MaterialApp(
      // home: TelaPrincipal(),
      routes: {
        '/init': (context) => TelaPrincipal(),
        '/sec': (context) => TelaSecundaria(),
      },
      initialRoute: '/init',
    ));

class TelaPrincipal extends StatefulWidget {
  TelaPrincipal({Key? key}) : super(key: key);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Principal'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text('Primeira Tela!'),
            ElevatedButton(
              onPressed: () {
                // Simples COM sobreposição
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TelaSecundaria()));
                // Simples SEM sobreposição
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => TelaSecundaria()));
                // Nomeado COM sobreposição
                Navigator.pushNamed(context, '/sec');
                // Nomeado SEM sobreposição
                Navigator.of(context).pushReplacementNamed('/sec');
              },
              child: Text('Ir para a segunda tela'),
            ),
          ],
        ),
      ),
    );
  }
}
