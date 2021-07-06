import 'package:flutter/material.dart';

class EntradaSlider extends StatefulWidget {
  EntradaSlider({Key? key}) : super(key: key);

  @override
  _EntradaSliderState createState() => _EntradaSliderState();
}

class _EntradaSliderState extends State<EntradaSlider> {
  var _valorArrasto = 0.0;
  var _label = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Botão Switch')),
      body: Container(
        padding: EdgeInsets.all(60),
        child: Column(
          children: [
            Slider(
              value: _valorArrasto,
              min: 0,
              max: 100,
              label: _label,
              divisions: 100,
              onChanged: (double novoValor) {
                setState(() {
                  _valorArrasto = novoValor;
                  _label = novoValor.toString();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
