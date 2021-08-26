import 'package:flutter/material.dart';
import 'package:ingles_com_abas/view/Animais.dart';
import 'package:ingles_com_abas/view/Numeros.dart';
import 'package:ingles_com_abas/view/Vogais.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        primaryColor: Color(0xff795548),
        scaffoldBackgroundColor: Color(0xfff5e9b9),
      ),
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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprenda Inglês'),
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 4.0,
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'Animais'),
            Tab(text: 'Números'),
            Tab(text: 'Vogais'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [Animais(), Numeros(), Vogais()],
      ),
    );
  }
}
