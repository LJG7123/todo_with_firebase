import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/models/user_model.dart';
import 'package:todo_with_firebase/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  int _currentStep = 0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final authProvider =
      StateNotifierProvider<AuthNotifier, UserModel?>((ref) => AuthNotifier());
  bool _isLoading = false;

  final emailRegEx = RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final passwordRegEx =
      RegExp(r'^(?=.*[a-zA-Z])(?=.*[!@#$%^&*])(?=.*[0-9]).{8,15}$');
  bool isEmailAvailable = false;
  bool isPasswordAvailable = false;
  bool isNameEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Stepper(
                steps: _steps(),
                currentStep: _currentStep,
                onStepContinue: (_currentStep == 0 && isEmailAvailable) ||
                        (_currentStep == 1 && isPasswordAvailable) ||
                        (_currentStep == 2 && !isNameEmpty)
                    ? () {
                        if (_currentStep < _steps().length - 1) {
                          setState(() {
                            _currentStep++;
                          });
                        } else {
                          signUpUser();
                        }
                      }
                    : null,
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep--;
                    });
                  }
                },
              )));
  }

  List<Step> _steps() => [
        Step(
          title: const Text(
            '이메일 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: '이메일',
              errorText: _emailController.text.isEmpty || isEmailAvailable
                  ? null
                  : "유효한 형식의 이메일을 입력해주세요.",
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                isEmailAvailable = emailRegEx.hasMatch(value);
              });
            },
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text(
            '비밀번호 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: '비밀번호',
                errorText: _passwordController.text.isEmpty ||
                        isPasswordAvailable
                    ? null
                    : "비밀번호는 8자 이상, 15자 이하의\n영문과 숫자, 특수문자의 조합으로 이루어져야 합니다."),
            obscureText: true,
            onChanged: (value) {
              setState(() {
                isPasswordAvailable = passwordRegEx.hasMatch(value);
              });
            },
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: const Text(
            '이름 입력',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '이름'),
            onChanged: (value) {
              setState(() {
                isNameEmpty = value.isEmpty;
              });
            },
          ),
          isActive: _currentStep >= 2,
        ),
      ];

  Future<void> signUpUser() async {
    final auth = ref.read(authProvider.notifier);

    if (_emailController.text.isEmpty ||
        !emailRegEx.hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("유효한 이메일을 입력하세요.")));
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("비밀번호는 최소 8자 이상이어야 합니다.")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var ret = await auth.signUp(
        _nameController.text, _emailController.text, _passwordController.text);
    if (ret) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("회원가입이 완료되었습니다.")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("회원가입에 실패했습니다.")));
    }
    setState(() {
      _isLoading = false;
    });
  }
}
