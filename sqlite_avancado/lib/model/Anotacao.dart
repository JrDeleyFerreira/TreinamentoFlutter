class Anotacao {
  int? id;
  late String titulo;
  late String descricao;
  late String data;

  Anotacao({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
    };
  }

  factory Anotacao.fromMap(Map<String, dynamic> map) {
    return Anotacao(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      data: map['data'],
    );
  }
}
