// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ItemController on ItemControllerBase, Store {
  final _$marcadoAtom = Atom(name: 'ItemControllerBase.marcado');

  @override
  bool get marcado {
    _$marcadoAtom.reportRead();
    return super.marcado;
  }

  @override
  set marcado(bool value) {
    _$marcadoAtom.reportWrite(value, super.marcado, () {
      super.marcado = value;
    });
  }

  @override
  String toString() {
    return '''
marcado: ${marcado}
    ''';
  }
}
