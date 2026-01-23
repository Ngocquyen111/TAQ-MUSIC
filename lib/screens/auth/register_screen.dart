import 'package:flutter/material.dart';
import '../../core/firebase_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final usernameCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A0000), Color(0xFF2D0000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),

                _label("Name"),
                _input(nameCtrl, "Nguyen Van A"),

                _label("Username"),
                _input(usernameCtrl, "taq123"),

                _label("Password"),
                _input(passCtrl, "", obscure: true),

                _label("Confirm Password"),
                _input(confirmCtrl, "", obscure: true),

                const SizedBox(height: 28),

                _button(
                  text: "Register",
                  onTap: () async {
                    if (nameCtrl.text.isEmpty ||
                        usernameCtrl.text.isEmpty ||
                        passCtrl.text != confirmCtrl.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Thông tin không hợp lệ")),
                      );
                      return;
                    }

                    final firebase = FirebaseService();
                    final user = await firebase.register(
                      name: nameCtrl.text,
                      username: usernameCtrl.text,
                      password: passCtrl.text,
                    );

                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đăng ký thành công")),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đăng ký thất bại")),
                      );
                    }
                  },
                ),

                const SizedBox(height: 12),
                _button(
                  text: "Back to login",
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
    ),
  );

  Widget _input(TextEditingController ctrl, String hint,
      {bool obscure = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _button({required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: 180,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC1C1),
          foregroundColor: Colors.black,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}