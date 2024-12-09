class TodoModel {
  String? id;
  String title;
  String author;
  List<String> comments = [];

  TodoModel(
      {this.id,
      required this.title,
      required this.author,
      required this.comments});

  void addComment(String comment) {
    comments.add(comment);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "comments": comments,
    };
  }

  factory TodoModel.fromJson(String id, Map<String, dynamic> json) {
    return TodoModel(
      id: id,
      title: json["title"],
      author: json["author"],
      comments:
          (json["comments"] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}
