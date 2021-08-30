import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var usuario = 'wanderley@yahoo.com.br';
  var senha = 'giga1258%';

  var auth = FirebaseAuth.instance;

  /// Criando um usuário autenticado
  await auth
      .createUserWithEmailAndPassword(email: usuario, password: senha)
      .then((value) => print(value.user?.email.toString()))
      .catchError((error) => print(error.toString()));

  /// Verificando qual o usuário logado
  var usuarioAtual = auth.currentUser;
  print(usuarioAtual?.email.toString());

  /// Deslogando usuário
  auth.signOut();

  /// Fazendo login no app
  auth
      .signInWithEmailAndPassword(email: usuario, password: senha)
      .then((value) => print(value.user?.email.toString()))
      .catchError((onError) => print(onError.toString()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
