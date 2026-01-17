import 'package:flutter/material.dart';
import '../../user_store.dart';
import '../home/main_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../../core/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool hidePassword = true;

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A0000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text("Tên đăng nhập:", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 6),
              _input(usernameCtrl),

              const SizedBox(height: 20),

              const Text("Password:", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 6),
              _passwordInput(),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton("Login", _login),
                  _actionButton("Register", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Hoặc tiếp tục bằng",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),

              const SizedBox(height: 16),

              // ===== GOOGLE LOGIN =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _loginWithGoogle,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.g_mobiledata,
                        color: Colors.black,
                        size: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _passwordInput() {
    return TextField(
      controller: passCtrl,
      obscureText: hidePassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            hidePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() => hidePassword = !hidePassword);
          },
        ),
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: 110,
      height: 38,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC1C1),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }

  void _login() {
    if (!UserStore.hasRegistered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bạn chưa đăng ký")),
      );
      return;
    }

    if (usernameCtrl.text == UserStore.username &&
        passCtrl.text == UserStore.password) {
      UserStore.isLoggedIn = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sai tên đăng nhập hoặc mật khẩu")),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    final user = await _firebaseService.signInWithGoogle();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập Google thất bại")),
      );
    }
  }
}
