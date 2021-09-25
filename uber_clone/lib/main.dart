import 'package:flutter/material.dart';
import 'gerador_rotas.dart';
import 'telas/home_page.dart';

final ThemeData? temaPadrao = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xff37474f),
    secondary: const Color(0xff546e7a),
  ),
);

void main() => runApp(
      MaterialApp(
        title: "Uber",
        home: const Home(),
        theme: temaPadrao,
        initialRoute: GeradorDeRotas.homePage,
        onGenerateRoute: GeradorDeRotas.gerarRotas,
        debugShowCheckedModeBanner: false,
      ),
    );
