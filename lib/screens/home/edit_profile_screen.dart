import 'package:flutter/material.dart';
import '../../user_store.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController birthdayCtrl;
  late TextEditingController passwordCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: UserStore.name);
    phoneCtrl = TextEditingController(text: UserStore.phone);
    birthdayCtrl = TextEditingController(text: UserStore.birthday);
    passwordCtrl = TextEditingController(text: UserStore.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa thông tin")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Họ tên"),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Số điện thoại"),
              ),
              TextField(
                controller: birthdayCtrl,
                decoration: const InputDecoration(labelText: "Ngày sinh"),
              ),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  UserStore.name = nameCtrl.text;
                  UserStore.phone = phoneCtrl.text;
                  UserStore.birthday = birthdayCtrl.text;
                  UserStore.password = passwordCtrl.text;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cập nhật thành công")),
                  );

                  // 👇 TRẢ VỀ TRUE ĐỂ BÁO PROFILE REFRESH
                  Navigator.pop(context, true);
                },
                child: const Text("Lưu thay đổi"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
