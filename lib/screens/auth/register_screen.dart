import 'package:flutter/material.dart';
import '../../user_store.dart';

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

                _label("Tên đăng nhập"),
                _input(usernameCtrl, "username123"),

                _label("Password"),
                _input(passCtrl, "", obscure: true),

                _label("Confirm Password"),
                _input(confirmCtrl, "", obscure: true),

                const SizedBox(height: 28),

                _button(
                  text: "Register",
                  onTap: () {
                    if (nameCtrl.text.isEmpty ||
                        usernameCtrl.text.isEmpty ||
                        passCtrl.text != confirmCtrl.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Thông tin không hợp lệ")),
                      );
                      return;
                    }

                    UserStore.name = nameCtrl.text;
                    UserStore.username = usernameCtrl.text;
                    UserStore.password = passCtrl.text;
                    UserStore.hasRegistered = true;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đăng ký thành công")),
                    );

                    Navigator.pop(context);
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

  // ===== LABEL =====
  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ===== INPUT BOX =====
  Widget _input(
      TextEditingController ctrl,
      String hint, {
        bool obscure = false,
      }) {
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

  // ===== BUTTON =====
  Widget _button({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 180,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC1C1),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}
