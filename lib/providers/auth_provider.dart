import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/services/auth_service.dart';

class AuthNotifier extends StateNotifier<String?> {
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
    await authService.signInUser(email, password).then((_) {
      state = email;
      result = true;
    }, onError: (_) {
      result = false;
    });
    return result;
  }

  Future<bool> singOut() async {
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
