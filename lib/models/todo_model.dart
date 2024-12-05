class TodoModel {
  String title;
  String author;

  TodoModel({required this.title, required this.author});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      title: json["title"],
      author: json["author"],
    );
  }
}
