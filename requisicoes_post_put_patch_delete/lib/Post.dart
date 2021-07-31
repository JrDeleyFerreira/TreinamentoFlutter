class Post {
  late int userId;
  late int? id;
  late String? title;
  late String? body;

  Post({
    required this.userId,
    this.id,
    this.title,
    this.body,
  });

  Map toJson() {
    return {
      "userId": this.userId,
      "id": this.id,
      "title": this.title,
      "body": this.body
    };
  }

  get getUserId => this.userId;
  set setUserId(userId) => this.userId = userId;

  get getId => this.id;
  set setId(id) => this.id = id;

  get getTitle => this.title;
  set setTitle(title) => this.title = title;

  get getBody => this.body;
  set setBody(body) => this.body = body;
}
