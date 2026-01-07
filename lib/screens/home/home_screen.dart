import 'package:flutter/material.dart';
import '../utils/user_store.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: UserStore.getEmail(),
      builder: (context, snapshot) {
        final email = snapshot.data ?? 'Chưa có email';

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Xin chào 👋',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(email),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  await UserStore.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                        (route) => false,
                  );
                },
                child: const Text('ĐĂNG XUẤT'),
              ),
            ],
          ),
        );
      },
    );
  }
}
