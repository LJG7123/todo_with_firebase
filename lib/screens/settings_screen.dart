import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool isResetButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "사용자 계정: ${auth?.email}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "이름: ${auth?.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  var ret = await authNotifier.signOut();
                  if (context.mounted && ret) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => route.settings.name == '/');
                  }
                },
                child: const Text("로그아웃"),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: (auth?.isSocialSignedIn ?? true)
                    ? "비밀번호를 재설정 할 수 없습니다."
                    : "",
                child: ElevatedButton(
                  onPressed: (auth?.isSocialSignedIn ?? true) ||
                          isResetButtonClicked
                      ? null
                      : () async {
                          if (await authNotifier.resetPassword()) {
                            setState(() {
                              isResetButtonClicked = true;
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("비밀번호 재설정 이메일을 전송하였습니다!")));
                            }
                          }
                        },
                  child: const Text("비밀번호 재설정"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
