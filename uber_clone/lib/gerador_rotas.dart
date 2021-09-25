import 'package:flutter/material.dart';
import 'telas/cadastro_usuario.dart';
import 'telas/corridas.dart';
import 'telas/home_page.dart';
import 'telas/painel_motorista.dart';
import 'telas/painel_passageiro.dart';

class GeradorDeRotas {
  static const homePage = '/';
  static const telaCadastro = '/cadastro';
  static const painelMotorista = '/painel-motorista';
  static const painelPassageiro = '/painel-passageiro';
  static const painelCorridas = '/corrida';

  static Route<dynamic>? gerarRotas(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => const Home());
      case telaCadastro:
        return MaterialPageRoute(builder: (_) => const Cadastro());
      case painelMotorista:
        return MaterialPageRoute(builder: (_) => const PainelMotorista());
      case painelPassageiro:
        return MaterialPageRoute(builder: (_) => const PainelPassageiro());
      case painelCorridas:
        return MaterialPageRoute(builder: (_) => Corrida(args));
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
