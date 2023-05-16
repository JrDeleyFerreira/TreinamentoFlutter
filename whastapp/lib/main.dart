import 'package:flutter/material.dart';
import 'Login.dart';
import 'RouteGenerator.dart';
import 'dart:io';

final ThemeData temaIOS =
    ThemeData(primaryColor: Colors.grey[200], hintColor: Color(0xff25D366));

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff075E54),
  hintColor: Color(0xff25D366),
);

void main() {
  runApp(MaterialApp(
    home: Login(),
    theme: Platform.isIOS ? temaIOS : temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
