import 'package:flutter/material.dart';
import '../../user_store.dart';
import '../../app_state.dart'; // ✅ thêm
import '../auth/login_screen.dart';
import 'profile_screen.dart';

// library
import '../library/favorite_screen.dart';
import '../library/recent_screen.dart';
import '../library/download_screen.dart';

// notification
import '../notification/notification_screen.dart';

// firebase
import '../../core/firebase_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color mainColor = Color(0xFF4A0000);
  static const Color cardColor = Color(0xFF5C0A0A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text(
          "Cài đặt",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Tài khoản"),
          _card(
            context,
            icon: Icons.person,
            title: "Trang cá nhân",
            onTap: () => _go(context, const ProfileScreen()),
          ),

          const SizedBox(height: 20),

          _sectionTitle("Thư viện"),
          _card(
            context,
            icon: Icons.favorite,
            title: "Mục yêu thích",
            onTap: () => _go(context, const FavoriteScreen()),
          ),
          _card(
            context,
            icon: Icons.history,
            title: "Gần đây",
            onTap: () => _go(context, const RecentScreen()),
          ),
          _card(
            context,
            icon: Icons.download,
            title: "Nhạc đã tải",
            onTap: () => _go(context, const DownloadScreen()),
          ),

          const SizedBox(height: 20),

          _sectionTitle("Khác"),
          _card(
            context,
            icon: Icons.notifications,
            title: "Thông báo",
            onTap: () => _go(context, const NotificationScreen()),
          ),

          const SizedBox(height: 30),

          _logoutCard(context),
        ],
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _card(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _logoutCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.redAccent),
        title: const Text(
          "Đăng xuất",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async {
          final firebaseService = FirebaseService();
          await firebaseService.signOut();

          UserStore.isLoggedIn = false;

          // ✅ reset skeleton cho lần login sau
          AppState.homeLoaded = false;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
          );
        },
      ),
    );
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}