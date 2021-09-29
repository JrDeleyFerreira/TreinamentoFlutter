import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BotaoAnimado extends StatelessWidget {
  AnimationController controller;
  late Animation largura;
  late Animation altura;
  late Animation opacidade;

  BotaoAnimado({Key? key, required this.controller})
      : largura = Tween<double>(begin: 0, end: 500).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.5, 1.0),
        )),
        altura = Tween<double>(begin: 0, end: 50).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.5, 0.7),
        )),
        opacidade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.6, 0.8),
        )),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? widget) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: largura.value,
        height: altura.value,
        child: Center(
          child: FadeTransition(
            opacity: opacidade.value,
            child: const Text(
              "Entrar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(255, 100, 127, 1),
              Color.fromRGBO(255, 123, 145, 1),
            ],
          ),
        ),
      ),
    );
  }
}
