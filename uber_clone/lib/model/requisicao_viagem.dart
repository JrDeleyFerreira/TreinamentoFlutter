import 'package:cloud_firestore/cloud_firestore.dart';
import 'destino_viagem.dart';
import 'usuario_app.dart';

class Requisicao {
  late String _id;
  late String _status;
  late Usuario _passageiro;
  late Usuario _motorista;
  late Destino _destino;

  Requisicao() {
    var banco = FirebaseFirestore.instance;

    DocumentReference ref = banco.collection("requisicoes").doc();
    id = ref.id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dadosPassageiro = {
      "nome": passageiro.nome,
      "email": passageiro.email,
      "tipoUsuario": passageiro.tipoUsuario,
      "idUsuario": passageiro.idUsuario,
      "latitude": passageiro.latitude,
      "longitude": passageiro.longitude,
    };

    Map<String, dynamic> dadosDestino = {
      "rua": destino.rua,
      "numero": destino.numero,
      "bairro": destino.bairro,
      "cep": destino.cep,
      "latitude": destino.latitude,
      "longitude": destino.longitude,
    };

    Map<String, dynamic> dadosRequisicao = {
      "id": id,
      "status": status,
      "passageiro": dadosPassageiro,
      "motorista": null,
      "destino": dadosDestino,
    };

    return dadosRequisicao;
  }

  get id => _id;
  set id(value) => _id = value;

  get status => _status;
  set status(value) => _status = value;

  get passageiro => _passageiro;
  set passageiro(value) => _passageiro = value;

  get motorista => _motorista;
  set motorista(value) => _motorista = value;

  get destino => _destino;
  set destino(value) => _destino = value;
}
