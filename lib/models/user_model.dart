class UserModel {
  String name;
  String email;

  UserModel({required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"],
      email: json["email"],
    );
  }
}
