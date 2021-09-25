import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber_clone/util/status_requisicao.dart';
import 'package:uber_clone/util/usuario_firebase.dart';

class PainelMotorista extends StatefulWidget {
  const PainelMotorista({Key? key}) : super(key: key);
  @override
  _PainelMotoristaState createState() => _PainelMotoristaState();
}

class _PainelMotoristaState extends State<PainelMotorista> {
  List<String> itensMenu = ["Configurações", "Deslogar"];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  var banco = FirebaseFirestore.instance;

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Configurações":
        break;
    }
  }

  _adicionarListenerRequisicoes() {
    final stream = banco
        .collection("requisicoes")
        .where("status", isEqualTo: StatusRequisicao.aguardando)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperaRequisicaoAtivaMotorista() async {
    //Recupera dados do usuario logado
    var firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    //Recupera requisicao ativa
    var documentSnapshot = await banco
        .collection("requisicao_ativa_motorista")
        .doc(firebaseUser!.uid)
        .get();

    var dadosRequisicao = documentSnapshot.data();

    if (dadosRequisicao == null) {
      _adicionarListenerRequisicoes();
    } else {
      var idRequisicao = dadosRequisicao["id_requisicao"];
      Navigator.pushReplacementNamed(context, "/corrida",
          arguments: idRequisicao);
    }
  }

  @override
  void initState() {
    super.initState();
    /*
    Recupera requisicao ativa para verificar se motorista está
    atendendo alguma requisição e envia ele para tela de corrida
    */
    _recuperaRequisicaoAtivaMotorista();
  }

  @override
  Widget build(BuildContext context) {
    var mensagemCarregando = Center(
      child: Column(
        children: const <Widget>[
          Text("Carregando requisições"),
          CircularProgressIndicator()
        ],
      ),
    );

    var mensagemNaoTemDados = const Center(
      child: Text(
        "Você não tem nenhuma requisição :( ",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel motorista"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return mensagemCarregando;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return const Text("Erro ao carregar os dados!");
                } else {
                  var querySnapshot = snapshot.data;
                  if (querySnapshot!.docs.isEmpty) {
                    return mensagemNaoTemDados;
                  } else {
                    return ListView.separated(
                        itemCount: querySnapshot.docs.length,
                        separatorBuilder: (context, indice) => const Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                        itemBuilder: (context, indice) {
                          List<DocumentSnapshot> requisicoes =
                              querySnapshot.docs.toList();
                          DocumentSnapshot item = requisicoes[indice];

                          String idRequisicao = item["id"];
                          String nomePassageiro = item["passageiro"]["nome"];
                          String rua = item["destino"]["rua"];
                          String numero = item["destino"]["numero"];

                          return ListTile(
                            title: Text(nomePassageiro),
                            subtitle: Text("destino: $rua, $numero"),
                            onTap: () {
                              Navigator.pushNamed(context, "/corrida",
                                  arguments: idRequisicao);
                            },
                          );
                        });
                  }
                }
            }
          }),
    );
  }
}
