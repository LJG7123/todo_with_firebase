import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/providers/todo_provider.dart';

class TodoDetailScreen extends ConsumerWidget {
  const TodoDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = TextEditingController();
    final index = ModalRoute.of(context)?.settings.arguments as int;
    var todo = ref.watch(todoProvider)[index];

    return Scaffold(
      appBar: AppBar(title: const Text("상세 화면")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "할 일: ${todo.title}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("댓글",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: todo.comments.length,
                      itemBuilder: (context, index) =>
                          Text(todo.comments[index]["content"]!),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              Expanded(
                  child: TextField(
                controller: commentController,
              )),
              IconButton.filled(
                  onPressed: () {
                    ref
                        .read(todoProvider.notifier)
                        .addComment(todo.id!, commentController.text);
                    commentController.clear();
                  },
                  icon: const Icon(Icons.add))
            ]),
          ],
        ),
      ),
    );
  }
}
