import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/models/user_model.dart';
import 'package:todo_with_firebase/services/auth_service.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, UserModel?>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null);

  final authService = AuthService.instance;

  Future<bool> signUp(String name, String email, String password) async {
    bool result = false;
    await authService.signUpUser(name, email, password).then((_) {
      result = true;
    }, onError: (_) {
      result = false;
    });
    return result;
  }

  Future<bool> signIn(String email, String password) async {
    bool result = false;
    await authService.signInUser(email, password).then((user) {
      state = user;
      result = true;
    }, onError: (_) {
      result = false;
    });
    return result;
  }

  Future<bool> signInWithGoogle() async {
    bool result = false;
    await authService.signInWithGoogle().then((user) {
      state = user;
      result = true;
    }, onError: (_) {
      result = false;
    });
    return result;
  }

  Future<bool> signOut() async {
    bool result = false;
    await authService.signOut().then((_) {
      state = null;
      result = true;
    }, onError: (_) {
      result = false;
    });
    return result;
  }
}
