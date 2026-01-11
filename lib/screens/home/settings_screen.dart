import 'package:flutter/material.dart';
import '../../user_store.dart';
import '../auth/login_screen.dart';
import 'profile_screen.dart';

// library
import '../library/favorite_screen.dart';
import '../library/recent_screen.dart';
import '../library/download_screen.dart';

// notification
import '../notification/notification_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
      ),
      body: ListView(
        children: [
          _item(
            context,
            Icons.person,
            "Trang cá nhân",
                () => _go(context, const ProfileScreen()),
          ),
          _item(
            context,
            Icons.favorite,
            "Mục yêu thích",
                () => _go(context, const FavoriteScreen()),
          ),
          _item(
            context,
            Icons.history,
            "Gần đây",
                () => _go(context, const RecentScreen()),
          ),
          _item(
            context,
            Icons.download,
            "Nhạc đã tải",
                () => _go(context, const DownloadScreen()),
          ),
          _item(
            context,
            Icons.notifications,
            "Thông báo",
                () => _go(context, const NotificationScreen()),
          ),
          _item(
            context,
            Icons.logout,
            "Đăng xuất",
                () {
              UserStore.isLoggedIn = false;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // ===== helper =====
  void _go(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  ListTile _item(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
