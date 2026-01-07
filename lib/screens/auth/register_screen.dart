import 'package:flutter/material.dart';
import '../../data/user_store.dart';
import '../home/home_page.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  void _register() {
    if (emailCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        confirmCtrl.text.isEmpty) {
      _show('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    if (passCtrl.text != confirmCtrl.text) {
      _show('Mật khẩu không khớp');
      return;
    }

    UserStore.register(emailCtrl.text, passCtrl.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B0A0A),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('REGISTER',
                style: TextStyle(color: Colors.white, fontSize: 28)),
            const SizedBox(height: 32),

            TextField(controller: emailCtrl, decoration: _input('Email')),
            const SizedBox(height: 16),

            TextField(
              controller: passCtrl,
              decoration: _input('Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: confirmCtrl,
              decoration: _input('Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _register,
                child: const Text('REGISTER'),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Đã có tài khoản? Login',
                  style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
