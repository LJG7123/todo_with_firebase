import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/models/todo_model.dart';
import 'package:todo_with_firebase/providers/auth_provider.dart';
import 'package:todo_with_firebase/providers/todo_provider.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todos = ref.watch(todoProvider);
    var userEmail = ref.read(authProvider);
    if (userEmail != null) {
      ref.read(todoProvider.notifier).getTodos(userEmail);
    } else {
      // TODO: 로그인 에러 처리
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            subtitle: Text(todos[index].author),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => AddTodoDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTodoDialog extends ConsumerWidget {
  final _titleController = TextEditingController();

  AddTodoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoProvider.notifier);
    final userEmail = ref.read(authProvider);

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
            if (_titleController.text.isNotEmpty && userEmail != null) {
              todoNotifier.addTodo(
                  TodoModel(title: _titleController.text, author: userEmail));
              Navigator.of(context).pop();
            }
          },
          child: const Text('추가'),
        ),
      ],
    );
  }
}
