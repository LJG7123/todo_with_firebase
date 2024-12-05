import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_with_firebase/models/todo_model.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final instance = TodoService();

  Future<void> addTodo(TodoModel todo) async {
    _firestore.collection("todos").add(todo.toJson());
  }
}
