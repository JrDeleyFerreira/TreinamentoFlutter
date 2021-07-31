class Post {
  late int userId;
  late int id;
  late String title;
  late String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  get getUserId => this.userId;
  set setUserId(userId) => this.userId = userId;

  get getId => this.id;
  set setId(id) => this.id = id;

  get getTitle => this.title;
  set setTitle(title) => this.title = title;

  get getBody => this.body;
  set setBody(body) => this.body = body;
}
