import 'package:flutter/material.dart';

class AnimacaoImplicita extends StatefulWidget {
  const AnimacaoImplicita({Key? key}) : super(key: key);

  @override
  _AnimacaoImplicitaState createState() => _AnimacaoImplicitaState();
}

class _AnimacaoImplicitaState extends State<AnimacaoImplicita> {
  bool _status = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          width: _status ? 200 : 300,
          height: _status ? 300 : 200,
          color: _status ? Colors.white : Colors.purpleAccent,
          curve: Curves.bounceIn,
          padding: const EdgeInsets.all(20),
          child: Image.asset('assets/logo.png'),
        ),
        ElevatedButton(
          child: const Text('Alterar'),
          onPressed: () {
            setState(() {
              _status = !_status;
            });
          },
        ),
      ],
    );
  }
}
