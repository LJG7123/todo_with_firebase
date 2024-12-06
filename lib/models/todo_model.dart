class TodoModel {
  String? id;
  String title;
  String author;

  TodoModel({this.id, required this.title, required this.author});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
    };
  }

  factory TodoModel.fromJson(String id, Map<String, dynamic> json) {
    return TodoModel(
      id: id,
      title: json["title"],
      author: json["author"],
    );
  }
}
