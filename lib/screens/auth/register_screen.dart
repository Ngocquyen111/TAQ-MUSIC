import 'package:flutter/material.dart';
import '../../user_store.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final birthdayCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Họ tên")),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email (@gmail.com)")),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Số điện thoại")),
              TextField(controller: birthdayCtrl, decoration: const InputDecoration(labelText: "Ngày sinh")),
              TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Mật khẩu")),
              TextField(controller: confirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Xác nhận mật khẩu")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isEmpty ||
                      phoneCtrl.text.isEmpty ||
                      birthdayCtrl.text.isEmpty ||
                      !emailCtrl.text.endsWith("@gmail.com") ||
                      passCtrl.text != confirmCtrl.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Thông tin không hợp lệ")),
                    );
                    return;
                  }

                  UserStore.name = nameCtrl.text;
                  UserStore.email = emailCtrl.text;
                  UserStore.phone = phoneCtrl.text;
                  UserStore.birthday = birthdayCtrl.text;
                  UserStore.password = passCtrl.text;
                  UserStore.hasRegistered = true;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đăng ký thành công")),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Đăng ký"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
