class Usuario {
  late String _idUsuario;
  late String _nome;
  late String _email;
  late String _senha;

  get idUsuario => _idUsuario;
  set idUsuario(value) => _idUsuario = value;

  get nome => _nome;
  set nome(value) => _nome = value;

  get email => _email;
  set email(value) => _email = value;

  get senha => _senha;
  set senha(value) => _senha = value;

  Usuario();

  Map<String, dynamic> toMap() {
    return {"idUsuario": _idUsuario, "nome": _nome, "email": _email};
  }
}
