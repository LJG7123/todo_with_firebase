class TodoModel {
  String? id;
  String title;
  String author;
  String createdAt;
  List<Map<String, String>> comments = [];

  TodoModel(
      {this.id,
      required this.title,
      required this.author,
      required this.createdAt,
      required this.comments});

  void addComment(String comment) {
    comments.add({
      "content": comment,
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "comments": comments,
      "createdAt": createdAt,
    };
  }

  factory TodoModel.fromJson(String id, Map<String, dynamic> json) {
    return TodoModel(
      id: id,
      title: json["title"],
      author: json["author"],
      createdAt: json["createdAt"],
      comments: (json["comments"] as List<dynamic>)
          .map((e) => {
                "content": e["content"].toString(),
                "createdAt": e["createdAt"].toString(),
              })
          .toList(),
    );
  }
}
