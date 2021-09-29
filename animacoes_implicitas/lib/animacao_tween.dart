import 'package:flutter/material.dart';

class AninmacaoTween extends StatefulWidget {
  const AninmacaoTween({Key? key}) : super(key: key);

  @override
  _AninmacaoTweenState createState() => _AninmacaoTweenState();
}

class _AninmacaoTweenState extends State<AninmacaoTween> {
  @override
  Widget build(BuildContext context) {
    return Center(
      /* Rotação da LOGO
      child: TweenAnimationBuilder(
        duration: const Duration(seconds: 2),
        tween: Tween<double>(begin: 0, end: 6.28),
        builder: (context, double angulo, widget) {
          return Transform.rotate(
            angle: angulo,
            child: Image.asset('assets/logo.png'),
          );
        },
      ),*/

      child: TweenAnimationBuilder(
        duration: const Duration(seconds: 2),
        tween: ColorTween(begin: Colors.white, end: Colors.orange),
        child: Image.asset('assets/estrelas.jpg'),
        builder: (context, Color? cor, widget) {
          return ColorFiltered(
            colorFilter: ColorFilter.mode(cor!, BlendMode.overlay),
            child: widget,
          );
        },
      ),
    );
  }
}
