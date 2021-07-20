import 'package:flutter/material.dart';
import 'TelaCliente.dart';
import 'TelaContato.dart';
import 'TelaEmpresa.dart';
import 'TelaServico.dart';

void main() {
  runApp(MaterialApp(
    home: HomePageATM(),
    debugShowCheckedModeBanner: false,

    /** USANDO ROTAS NOMEADAS - Prefira isolar o HomePageATM nesse caso:
     * routes: {
      '/': (context) => HomePageATM(),
      '/emp': (context) => TelaEmpresa(),
      '/serv': (context) => TelaServico(),
      '/cli': (context) => TelaCliente(),
      '/ctt': (context) => TelaContato()
    },
    initialRoute: '/',
    */
  ));
}

class HomePageATM extends StatefulWidget {
  HomePageATM({Key? key}) : super(key: key);

  @override
  _HomePageATMState createState() => _HomePageATMState();
}

class _HomePageATMState extends State<HomePageATM> {
  var _imgCliente = AssetImage('resources/menu_cliente.png');
  var _imgContato = AssetImage('resources/menu_contato.png');
  var _imgEmpresa = AssetImage('resources/menu_empresa.png');
  var _imgServico = AssetImage('resources/menu_servico.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ATM Consultoria'),
        backgroundColor: Colors.green.shade400,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("resources/logo.png"),
            _montaRowTelaInicial(
                'empresa', 'servico', _imgEmpresa, _imgServico),
            _montaRowTelaInicial(
                'cliente', 'contato', _imgCliente, _imgContato),
          ],
        ),
      ),
    );
  }

  Padding _montaRowTelaInicial(
      String tela1, String tela2, AssetImage img1, AssetImage img2) {
    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () => _abreTelaDestino(tela1),
            child: Image(image: img1),
          ),
          GestureDetector(
            onTap: () => _abreTelaDestino(tela2),
            child: Image(image: img2),
          )
        ],
      ),
    );
  }

  _abreTelaDestino(String tela) {
    switch (tela) {
      case 'empresa':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TelaEmpresa()));
        break;
      case 'servico':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TelaServico()));
        break;
      case 'cliente':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TelaCliente()));
        break;
      case 'contato':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TelaContato()));
        break;
    }

    /** CASO UTILIZE AS ROTAS NOMEADAS:
     * case 'empresa':
        Navigator.pushNamed(context, '/emp');
        break;
       case 'servico':
        Navigator.pushNamed(context, '/serv');
        break;
       case 'cliente':
        Navigator.pushNamed(context, '/cli');
        break;
       case 'contato':
        Navigator.pushNamed(context, '/ctt');
        break;
     */
  }
}
