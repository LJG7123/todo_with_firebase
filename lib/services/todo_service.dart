import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_with_firebase/models/todo_model.dart';
import 'package:todo_with_firebase/services/auth_service.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService authService = AuthService.instance;
  static final instance = TodoService();

  Future<List<TodoModel>> getTodos() async {
    var email = authService.userCredential?.user?.email;
    if (email == null) {
      throw Exception('login error');
    }
    var snapshot = await _firestore
        .collection("todos")
        .where("author", isEqualTo: email)
        .get();
    return snapshot.docs
        .map((e) => TodoModel.fromJson(e.id, e.data()))
        .toList();
  }

  Future<void> addTodo(TodoModel todo) async {
    _firestore.collection("todos").add(todo.toJson());
  }

  Future<void> deleteTodo(String id) async {
    _firestore.collection("todos").doc(id).delete();
  }

  Future<void> updateTodo(String id, TodoModel todo) async {
    _firestore.collection("todos").doc(id).set(todo.toJson());
  }
}
