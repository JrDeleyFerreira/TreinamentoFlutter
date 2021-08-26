import 'package:abas_paginas/view/PrimeiraPagina.dart';
import 'package:abas_paginas/view/SegundaPagina.dart';
import 'package:abas_paginas/view/TerceiraPagina.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Abas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'HOME', icon: Icon(Icons.home)),
            Tab(text: 'E-MAIL', icon: Icon(Icons.email)),
            Tab(text: 'CONTA', icon: Icon(Icons.account_circle)),
          ],
        ),
      ),
      body: TabBarView(
        children: [PrimeiraPagina(), SegundaPagina(), TerceiraPagina()],
        controller: _tabController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
