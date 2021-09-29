import 'dart:ui';
import 'package:animacao_login_app_ishow/botao_animado.dart';
import 'package:flutter/material.dart';
import 'input_customizado.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  /// Variáveis de Classe
  late AnimationController _animationController;
  late Animation _animacaoBlur;
  late Animation _animacaoFade;
  late Animation _animacaoSize;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animacaoBlur = Tween<double>(begin: 5, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    _animacaoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuint,
      ),
    );

    _animacaoSize = Tween<double>(begin: 0, end: 500).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.decelerate,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AnimatedBuilder(
              animation: _animacaoBlur,
              builder: (context, widget) {
                return Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/fundo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: BackdropFilter(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          child: FadeTransition(
                            opacity: _animacaoFade.value,
                            child: Image.asset('assets/detalhe1.png'),
                          ),
                        ),
                        Positioned(
                            left: 50,
                            child: FadeTransition(
                              opacity: _animacaoFade.value,
                              child: Image.asset('assets/detalhe2.png'),
                            )),
                      ],
                    ),
                    filter: ImageFilter.blur(
                      sigmaX: _animacaoBlur.value,
                      sigmaY: _animacaoBlur.value,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _animacaoSize,
                    builder: (context, widget) {
                      return Container(
                        width: _animacaoSize.value,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 15,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          children: const [
                            InputCustomizado(
                                hint: "Email",
                                obscure: false,
                                icon: Icon(Icons.person)),
                            InputCustomizado(
                                hint: "Senha",
                                obscure: true,
                                icon: Icon(Icons.lock)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BotaoAnimado(controller: _animationController),
                  const SizedBox(
                    height: 10,
                  ),
                  FadeTransition(
                    opacity: _animacaoFade.value,
                    child: const Text(
                      "Esqueci minha senha!",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 100, 127, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
