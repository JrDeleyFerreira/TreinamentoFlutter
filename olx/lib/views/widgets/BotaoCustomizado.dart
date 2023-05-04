import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  BotaoCustomizado(
      {@required this.texto, this.corTexto = Colors.white, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        this.texto,
        style: TextStyle(color: this.corTexto, fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        foregroundColor: Color(0xff9c27b0),
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      ),
      onPressed: this.onPressed,
    );
  }
}
