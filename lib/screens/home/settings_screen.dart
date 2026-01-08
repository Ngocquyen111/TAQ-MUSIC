import 'package:flutter/material.dart';
import '../../user_store.dart';
import '../auth/login_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt")),
      body: ListView(
        children: [
          _item(context, Icons.person, "Trang cá nhân", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }),
          _item(context, Icons.favorite, "Yêu thích", () {}),
          _item(context, Icons.history, "Gần đây", () {}),
          _item(context, Icons.download, "Nhạc đã tải", () {}),
          _item(context, Icons.notifications, "Thông báo", () {}),
          _item(context, Icons.logout, "Đăng xuất", () {
            UserStore.isLoggedIn = false;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
            );
          }),
        ],
      ),
    );
  }

  ListTile _item(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
