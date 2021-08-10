import 'dart:convert';

class Video {
  late String? id;
  late String? titulo;
  late String? descricao;
  late String? imagemTumb;
  late String? canal;

  Video({
    this.id,
    this.titulo,
    this.descricao,
    this.imagemTumb,
    this.canal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'imagemTumb': imagemTumb,
      'canal': canal,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id']['videoId'],
      titulo: map['snippet']['titulo'],
      descricao: map['descricao'],
      imagemTumb: map['snippet']['thumbnails']['high']['url'],
      canal: map['snippet']['channelId'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Video.fromJson(String source) => Video.fromMap(json.decode(source));
}
