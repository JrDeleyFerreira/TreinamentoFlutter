import 'package:flutter/material.dart';

class AnimacoesExplicitasConstruidas extends StatefulWidget {
  const AnimacoesExplicitasConstruidas({Key? key}) : super(key: key);

  @override
  _AnimacoesExplicitasConstruidasState createState() =>
      _AnimacoesExplicitasConstruidasState();
}

class _AnimacoesExplicitasConstruidasState
    extends State<AnimacoesExplicitasConstruidas>
    with SingleTickerProviderStateMixin {
  /// Variáveis da classe
  late AnimationController _animationController;
  late AnimationStatus _animationStatus;

  /* @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  } */

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )
      ..repeat()
      ..addStatusListener((status) => _animationStatus = status);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            width: 300,
            height: 400,
            child: RotationTransition(
              alignment: Alignment.center,
              child: Image.asset('assets/logo.png'),
              turns: _animationController,
            ),
          ),
          ElevatedButton(
            child: const Text('Pressione'),
            onPressed: () {
              /* _animationController.isAnimating
                  ? _animationController.stop()
                  : _animationController.repeat(); */
              _animationStatus == AnimationStatus.dismissed
                  ? _animationController.forward()
                  : _animationController.reverse();
            },
          ),
        ],
      ),
    );
  }
}
