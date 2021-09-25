import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone/model/usuario_app.dart';

class UsuarioFirebase {
  static Future<User?> getUsuarioAtual() async {
    var auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  static Future<Usuario> getDadosUsuarioLogado() async {
    var firebaseUser = await getUsuarioAtual();
    var idUsuario = firebaseUser?.uid;

    var banco = FirebaseFirestore.instance;
    var snapshot = await banco.collection("usuarios").doc(idUsuario).get();
    var dados = snapshot.data();

    var tipoUsuario = dados!["tipoUsuario"];
    var email = dados["email"];
    var nome = dados["nome"];

    var usuario = Usuario();
    usuario.idUsuario = idUsuario;
    usuario.tipoUsuario = tipoUsuario;
    usuario.email = email;
    usuario.nome = nome;

    return usuario;
  }

  static atualizarDadosLocalizacao(
    String idRequisicao,
    double lat,
    double lon,
    String tipo,
  ) async {
    var banco = FirebaseFirestore.instance;

    var usuario = await getDadosUsuarioLogado();
    usuario.latitude = lat;
    usuario.longitude = lon;

    banco.collection("requisicoes").doc(idRequisicao).update({
      "$tipo": usuario.toMap(),
    });
  }
}
