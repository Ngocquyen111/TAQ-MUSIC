import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/firebase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool hidePassword = true;
  bool hideConfirm = true;

  String? usernameError;
  String? passwordError;
  bool checkingUsername = false;

  final firebase = FirebaseService();
  Timer? _debounce;

  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    usernameCtrl.addListener(_onUsernameChanged);

    // kiểm tra độ dài + trùng khớp
    passCtrl.addListener(_validatePassword);
    confirmCtrl.addListener(_validatePassword);
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    nameCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ================= USERNAME CHECK =================
  void _onUsernameChanged() {
    final value = usernameCtrl.text.trim();

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (value.isEmpty) {
        setState(() => usernameError = null);
        return;
      }

      setState(() => checkingUsername = true);

      final exists = await firebase.isUsernameExists(value);

      if (!mounted) return;

      setState(() {
        checkingUsername = false;
        usernameError =
        exists ? "Username đã tồn tại, vui lòng chọn tên khác" : null;
      });
    });
  }

  // ================= PASSWORD VALIDATE =================
  void _validatePassword() {
    final pass = passCtrl.text;
    final confirm = confirmCtrl.text;

    setState(() {
      if (pass.isEmpty) {
        passwordError = null;
        return;
      }

      if (pass.length < 6) {
        passwordError = "Mật khẩu phải có ít nhất 6 ký tự";
        return;
      }

      if (confirm.isNotEmpty && pass != confirm) {
        passwordError = "Mật khẩu chưa trùng khớp";
        return;
      }

      passwordError = null;
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
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
                _input(
                  usernameCtrl,
                  "taq123",
                  errorText: usernameError,
                  suffix: checkingUsername
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : null,
                ),

                _label("Password"),
                _input(
                  passCtrl,
                  "",
                  obscure: hidePassword,
                  errorText: passwordError,
                  suffix: _eyeIcon(
                    hidePassword,
                        () => setState(() => hidePassword = !hidePassword),
                  ),
                ),

                _label("Confirm Password"),
                _input(
                  confirmCtrl,
                  "",
                  obscure: hideConfirm,
                  errorText: passwordError,
                  suffix: _eyeIcon(
                    hideConfirm,
                        () => setState(() => hideConfirm = !hideConfirm),
                  ),
                ),

                const SizedBox(height: 28),

                _button(
                  text: "Register",
                  onTap: () async {
                    if (nameCtrl.text.isEmpty ||
                        usernameCtrl.text.isEmpty ||
                        passCtrl.text.isEmpty ||
                        usernameError != null ||
                        passwordError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Thông tin không hợp lệ")),
                      );
                      return;
                    }

                    await firebase.register(
                      name: nameCtrl.text.trim(),
                      username: usernameCtrl.text.trim(),
                      password: passCtrl.text,
                    );

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

  // ================= HELPERS =================
  Widget _label(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    ),
  );

  Widget _input(
      TextEditingController ctrl,
      String hint, {
        bool obscure = false,
        String? errorText,
        Widget? suffix,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 6),
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
              suffixIcon: suffix,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          )
        else
          const SizedBox(height: 10),
      ],
    );
  }

  Widget _eyeIcon(bool hidden, VoidCallback onTap) {
    return IconButton(
      icon: Icon(hidden ? Icons.visibility_off : Icons.visibility),
      onPressed: onTap,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}