import 'dart:io';

import 'package:flutter/material.dart';

class FormularioValidacaoImagens extends StatefulWidget {
  const FormularioValidacaoImagens({Key? key}) : super(key: key);

  @override
  _FormularioValidacaoImagensState createState() =>
      _FormularioValidacaoImagensState();
}

class _FormularioValidacaoImagensState
    extends State<FormularioValidacaoImagens> {
  // Variáveis da classe
  late List<File> _listaImagens;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validando Campos NÃO textuais')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: FormField<List>(
            initialValue: _listaImagens,
            validator: (imagens) {/* imagens é a lista definida */},
            builder: (state) {
              return Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _listaImagens.length + 1,
                      itemBuilder: (context, indice) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_a_photo_rounded),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
