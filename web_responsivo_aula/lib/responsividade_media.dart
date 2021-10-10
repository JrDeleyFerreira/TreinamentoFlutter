import 'package:flutter/material.dart';

class ResponsividadeMediaQuery extends StatefulWidget {
  const ResponsividadeMediaQuery({Key? key}) : super(key: key);

  @override
  _ResponsividadeMediaQueryState createState() =>
      _ResponsividadeMediaQueryState();
}

class _ResponsividadeMediaQueryState extends State<ResponsividadeMediaQuery> {
  @override
  Widget build(BuildContext context) {
    var alturaContainer = MediaQuery.of(context).size.height;
    var larguraContainer = MediaQuery.of(context).size.width;
    var alturaBarraStatus = MediaQuery.of(context).padding.top;
    var alturaAppBar = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Responsividade')),
      body: Column(
        children: [
          Container(
            width: larguraContainer,
            height: alturaContainer - alturaAppBar - alturaBarraStatus,
            color: Colors.blueGrey.shade600,
          ),
        ],
      ),
    );
  }
}
