import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "🎉 Đăng ký thành công",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
