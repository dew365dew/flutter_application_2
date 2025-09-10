import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullnameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final confirmPasswordCtl = TextEditingController();

  void showMessage(String message, [Color color = Colors.red]) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> register() async {
    final fullname = fullnameCtl.text.trim();
    final phone = phoneCtl.text.trim();
    final email = emailCtl.text.trim();
    final password = passwordCtl.text.trim();
    final confirmPassword = confirmPasswordCtl.text.trim();

    // ตรวจสอบช่องว่าง
    if ([
      fullname,
      phone,
      email,
      password,
      confirmPassword,
    ].any((e) => e.isEmpty)) {
      showMessage("กรุณากรอกข้อมูลให้ครบ");
      return;
    }

    // ตรวจสอบรหัสผ่านตรงกัน
    if (password != confirmPassword) {
      showMessage("รหัสผ่านไม่ตรงกัน");
      return;
    }

    try {
      // ส่งข้อมูลสมัครสมาชิก
      final data = {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": "http://192.168.1.3:3000/contents/default.png",
        "password": password,
      };

      final response = await http.post(
        Uri.parse("http://192.168.1.3:3000/customers"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        showMessage("สมัครสมาชิกสำเร็จ", Colors.green);
        Navigator.pop(context); // กลับหน้า login
      } else {
        showMessage("สมัครสมาชิกไม่สำเร็จ (${response.statusCode})");
      }
    } catch (e) {
      showMessage("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ชื่อ-นามสกุล"),
              const SizedBox(height: 8),
              TextField(
                controller: fullnameCtl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Text("หมายเลขโทรศัพท์"),
              const SizedBox(height: 8),
              TextField(
                controller: phoneCtl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Text("อีเมล์"),
              const SizedBox(height: 8),
              TextField(
                controller: emailCtl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Text("รหัสผ่าน"),
              const SizedBox(height: 8),
              TextField(
                controller: passwordCtl,
                obscureText: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Text("ยืนยันรหัสผ่าน"),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordCtl,
                obscureText: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              Center(
                child: FilledButton(
                  onPressed: register,
                  child: const Text('สมัครสมาชิก'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('หากมีบัญชีอยู่แล้ว?'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
