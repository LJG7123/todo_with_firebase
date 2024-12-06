import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/models/todo_model.dart';
import 'package:todo_with_firebase/providers/auth_provider.dart';
import 'package:todo_with_firebase/providers/todo_provider.dart';

class TodoListScreen extends ConsumerWidget {
  TodoListScreen({super.key});

  final todoProvider = StateNotifierProvider<TodoNotifier, List<TodoModel>>(
      (ref) => TodoNotifier());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            subtitle: Text(todos[index].author),
            trailing: IconButton(
                onPressed: () {
                  ref.read(todoProvider.notifier).deleteTodo(todos[index].id!);
                },
                icon: const Icon(Icons.delete)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AddTodoDialog(todoProvider: todoProvider));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTodoDialog extends ConsumerWidget {
  final _titleController = TextEditingController();
  final StateNotifierProvider<TodoNotifier, List<TodoModel>> todoProvider;

  AddTodoDialog({super.key, required this.todoProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoProvider.notifier);
    final user = ref.read(authProvider);

    return AlertDialog(
      title: const Text("Add Todo"),
      content: TextField(
        controller: _titleController,
        decoration: const InputDecoration(labelText: "제목"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty && user != null) {
              todoNotifier.addTodo(
                  TodoModel(title: _titleController.text, author: user.email));
              Navigator.of(context).pop();
            }
          },
          child: const Text('추가'),
        ),
      ],
    );
  }
}
