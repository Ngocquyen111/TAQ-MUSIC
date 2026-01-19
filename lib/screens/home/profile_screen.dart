import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔹 ADDED
import '../../user_store.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  // 🔹 ADDED: key lưu avatar
  static const String _avatarKey = 'user_avatar_path';

  // 🔹 ADDED: load avatar khi mở màn hình
  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  // 🔹 ADDED: đọc avatar từ SharedPreferences
  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_avatarKey);
    if (path != null && File(path).existsSync()) {
      setState(() {
        _avatarImage = File(path);
      });
    }
  }

  // ✅ CHỌN ẢNH TỪ THIẾT BỊ
  Future<void> _pickAvatar() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarImage = File(image.path);
      });

      // 🔹 ADDED: lưu avatar
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_avatarKey, image.path);
    }
  }

  Widget info(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A0000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A0000),
        title: const Text("Trang cá nhân"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              );
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

          // ================= AVATAR =================
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.green,
                    backgroundImage:
                    _avatarImage != null ? FileImage(_avatarImage!) : null,
                    child: _avatarImage == null
                        ? const Icon(Icons.person,
                        size: 60, color: Colors.white)
                        : null,
                  ),

                  // 🔹 ICON DẤU +
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ================= TÊN =================
          Center(
            child: Text(
              UserStore.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================= THÔNG TIN =================
          info("Email", UserStore.email),
          info("Số điện thoại", UserStore.phone),
          info("Ngày sinh", UserStore.birthday),
          info("Mật khẩu", "******"),
        ],
      ),
    );
  }
}
