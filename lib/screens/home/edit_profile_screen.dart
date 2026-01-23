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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Chỉnh sửa hồ sơ"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ================= AVATAR =================
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.pinkAccent,
                    child: Text(
                      UserStore.name.isNotEmpty
                          ? UserStore.name[0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Chỉnh sửa thông tin cá nhân",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ================= FORM =================
            _inputField(
              controller: nameCtrl,
              label: "Họ và tên",
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            _inputField(
              controller: phoneCtrl,
              label: "Số điện thoại",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _inputField(
              controller: birthdayCtrl,
              label: "Ngày sinh",
              icon: Icons.cake,
            ),
            const SizedBox(height: 16),



            const SizedBox(height: 32),

            // ================= SAVE BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _saveProfile,
                child: const Text(
                  "Lưu thay đổi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.pinkAccent),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _saveProfile() {
    UserStore.name = nameCtrl.text;
    UserStore.phone = phoneCtrl.text;
    UserStore.birthday = birthdayCtrl.text;
    UserStore.password = passwordCtrl.text;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cập nhật thông tin thành công"),
        backgroundColor: Colors.pinkAccent,
      ),
    );

    Navigator.pop(context, true);
  }
}