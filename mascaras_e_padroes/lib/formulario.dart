import 'package:flutter/material.dart';
import 'package:validadores/Validador.dart';

class Formulario extends StatefulWidget {
  const Formulario({Key? key}) : super(key: key);

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();
  var _cpfController = TextEditingController();

  late String? _cpf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (valor) {
                  return Validador()
                      .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatório!')
                      .add(Validar.CPF, msg: 'CPF inválido!')
                      .valido(valor);
                },
                decoration: const InputDecoration(
                  hintText: 'Digite o seu Nome:',
                ),
                controller: _cpfController,
                onSaved: (valor) {
                  _cpf = valor;
                },
              ),
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Usando controller
                    setState(() => _cpf = _cpfController.text);
                    // Usando onSaved:(){}
                    _formKey.currentState!.save();
                  } else {
                    // Faz outra ação
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
