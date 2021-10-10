import 'package:flutter/material.dart';

class ResponsividadeWrap extends StatefulWidget {
  const ResponsividadeWrap({Key? key}) : super(key: key);

  @override
  _ResponsividadeWrapState createState() => _ResponsividadeWrapState();
}

class _ResponsividadeWrapState extends State<ResponsividadeWrap> {
  var altura = 100.0;
  var largura = 200.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wrap')),
      body: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 5,
          children: [
            Container(
              height: altura,
              width: largura,
              color: Colors.yellow,
            ),
            Container(
              height: altura,
              width: largura,
              color: Colors.green,
            ),
            Container(
              height: altura,
              width: largura,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
