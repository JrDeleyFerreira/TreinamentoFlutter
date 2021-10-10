import 'package:flutter/material.dart';
import 'package:flutter_web_aula/Orientacao.dart';
import 'package:flutter_web_aula/loja_virtual.dart';
import 'package:flutter_web_aula/regras_layout.dart';
import 'package:flutter_web_aula/responsividade_media_query.dart';
import 'package:flutter_web_aula/responsividade_row_col.dart';
import 'package:flutter_web_aula/responsividade_wrap.dart';

void main() {
  runApp(MaterialApp(
    title: "Flutter Web",
    debugShowCheckedModeBanner: false,
    //home: ResponsividadeMediaQuery(),
    //home: ResponsividadeRowCol(),
    //home: ResponsividadeWrap(),
    //home: Orientacao(),
    //home: RegrasLayout(),
    home: LojaVirtual(),
  ));
}

