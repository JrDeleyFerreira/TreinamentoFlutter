import 'package:mobx/mobx.dart';

class ControllerMob {
  final _contador = Observable<int>(0);
  late Action incrementar;

  get contador => _contador.value;
  set contador(value) => _contador.value = value;

  ControllerMob() {
    incrementar = Action(_incrementarValor);
  }

  void _incrementarValor() {
    contador++;
  }
}
