import 'package:flutter/material.dart';

class MaisSobreAnimacoes extends StatefulWidget {
  const MaisSobreAnimacoes({Key? key}) : super(key: key);

  @override
  _MaisSobreAnimacoesState createState() => _MaisSobreAnimacoesState();
}

class _MaisSobreAnimacoesState extends State<MaisSobreAnimacoes>
    with SingleTickerProviderStateMixin {
  /// Variáveis da Classe
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(60, 60))
            .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: AnimatedBuilder(
        animation: _animation,
        child: Stack(
          children: [
            Positioned(
              width: 180,
              height: 180,
              top: 0,
              left: 0,
              child: Image.asset('assets/logo.png'),
            ),
          ],
        ),
        builder: (context, widget) {
          return Transform.translate(
            offset: _animation.value,
            child: widget,
          );
        },
      ),
    );
  }
}
