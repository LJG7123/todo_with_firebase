import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/models/todo_model.dart';
import 'package:todo_with_firebase/services/todo_service.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, List<TodoModel>>(
    (ref) => TodoNotifier());

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  TodoNotifier() : super([]) {
    getTodos();
  }
  final todoService = TodoService.instance;

  void getTodos() async {
    state = await todoService.getTodos();
  }

  void addTodo(TodoModel todo) {
    todoService.addTodo(todo).whenComplete(() {
      getTodos();
    });
  }

  void deleteTodo(String id) {
    todoService.deleteTodo(id).whenComplete(() {
      getTodos();
    });
  }
}
