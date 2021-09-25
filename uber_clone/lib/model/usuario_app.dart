class Usuario {
  late String _idUsuario;
  late String _nome;
  late String _email;
  late String _senha;
  late String _tipoUsuario;

  late double _latitude;
  late double _longitude;

  get idUsuario => _idUsuario;
  set idUsuario(value) => _idUsuario = value;

  get nome => _nome;
  set nome(value) => _nome = value;

  get email => _email;
  set email(value) => _email = value;

  get senha => _senha;
  set senha(value) => _senha = value;

  get tipoUsuario => _tipoUsuario;
  set tipoUsuario(value) => _tipoUsuario = value;

  get latitude => _latitude;
  set latitude(value) => _latitude = value;

  get longitude => _longitude;
  set longitude(value) => _longitude = value;

  Usuario();

  Map<String, dynamic> toMap() {
    return {
      "idUsuario": idUsuario,
      "nome": nome,
      "email": email,
      "tipoUsuario": tipoUsuario,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  String verificaTipoUsuario(bool tipoUsuario) {
    return tipoUsuario ? "motorista" : "passageiro";
  }
}
