import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/screens/settings_screen.dart';
import 'package:todo_with_firebase/screens/sign_in_screen.dart';
import 'package:todo_with_firebase/screens/sign_up_screen.dart';
import 'package:todo_with_firebase/screens/todo_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: _routes,
    );
  }

  final _routes = <String, WidgetBuilder>{
    '/': (context) => SignInScreen(),
    '/signUp': (context) => const SignUpScreen(),
    '/todos': (context) => const TodoListScreen(),
    '/settings': (context) => const SettingsScreen(),
  };
}
