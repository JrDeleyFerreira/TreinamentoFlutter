import 'package:mobx/mobx.dart';
part 'controller_auto.g.dart';

class ControllerAutoMobX = ControllerBase with _$ControllerAutoMobX;

abstract class ControllerBase with Store {
  @observable
  var contador = 0;

  @action
  incrementarValor() {
    contador++;
  }
}
