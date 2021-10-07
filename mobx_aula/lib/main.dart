import 'package:flutter/material.dart';
import 'package:mobxaula/controller.dart';
import 'package:provider/provider.dart';
import 'home.dart';

void main() {
  runApp(
    MultiProvider(
      child: MaterialApp(
        home: Home(),
      ),
      providers: [Provider<Controller>(create: (_) => Controller())],
    ),
  );
}
