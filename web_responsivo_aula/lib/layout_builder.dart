import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout Builder')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder: (context, regrasLayout) {
            var largura = regrasLayout.maxWidth;
            if (largura < 600) {
            } // Celulares
            else if (largura > 600 && largura < 900) {
            } // Tablets
            else {} // Monitores
            return Container();
          },
        ),
      ),
    );
  }
}
