class Destino {
  late String _rua;
  late String _numero;
  late String _cidade;
  late String _bairro;
  late String _cep;

  late double _latitude;
  late double _longitude;

  Destino();

  get rua => _rua;
  set rua(value) => _rua = value;

  get numero => _numero;
  set numero(value) => _numero = value;

  get cidade => _cidade;
  set cidade(value) => _cidade = value;

  get bairro => _bairro;
  set bairro(value) => _bairro = value;

  get cep => _cep;
  set cep(value) => _cep = value;

  get latitude => _latitude;
  set latitude(value) => _latitude = value;

  get longitude => _longitude;
  set longitude(value) => _longitude = value;
}
