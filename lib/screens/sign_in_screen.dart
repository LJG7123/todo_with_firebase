import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_with_firebase/providers/auth_provider.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "ID"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  bool ret = await authNotifier.signIn(
                      _emailController.text, _passwordController.text);
                  if (context.mounted) {
                    if (ret) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Login success!'),
                      ));
                      Navigator.pushNamedAndRemoveUntil(context, '/todos',
                          (route) => route.settings.name == '/todos');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Login failed!'),
                      ));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8A2BE2)),
                child:
                    const Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signUp');
              },
              child: const Text('회원가입',
                  style: TextStyle(color: Color(0xff8A2BE2))),
            ),
            const SizedBox(height: 10),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                bool ret = await authNotifier.signInWithGoogle();
                if (context.mounted) {
                  if (ret) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Login success!'),
                    ));
                    Navigator.pushNamedAndRemoveUntil(context, '/todos',
                        (route) => route.settings.name == '/todos');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Login failed!'),
                    ));
                  }
                }
              },
              icon: SvgPicture.asset('assets/images/android_light_rd_SI.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
