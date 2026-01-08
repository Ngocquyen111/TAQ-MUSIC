import 'package:flutter/material.dart';
import '../../user_store.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget info(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang cá nhân"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // 👇 CHỜ KẾT QUẢ TỪ MÀN CHỈNH SỬA
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              );

              // 👇 NẾU CÓ CẬP NHẬT → REFRESH UI
              if (updated == true) {
                setState(() {});
              }
            },
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              UserStore.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          info("Email", UserStore.email),
          info("Số điện thoại", UserStore.phone),
          info("Ngày sinh", UserStore.birthday),
          info("Mật khẩu", "******"),
        ],
      ),
    );
  }
}
