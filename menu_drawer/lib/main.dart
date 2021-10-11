import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Drawer'),
        backgroundColor: Colors.purpleAccent,
      ),
      drawer: Drawer(
        child: Column(
          children: const [
            UserAccountsDrawerHeader(
              currentAccountPicture: ClipOval(
                child: Icon(Icons.personal_injury_sharp),
              ),
              currentAccountPictureSize: Size.fromRadius(16),
              accountName: Text('Wanderley Ferreira'),
              accountEmail: Text('ferreirajr.wanderley@gmail.com'),
            ),
          ],
        ),
      ),
      // drawer: const Padding(
      //   padding: EdgeInsets.all(8.0),
      //   child: Drawer(
      //     semanticLabel: 'Teste',
      //     child: ListTile(
      //       leading: Icon(Icons.home_outlined),
      //       title: Text('Menu Drawer'),
      //       subtitle: Text('Modelo'),
      //     ),
      //   ),
      // ),
    );
  }
}
