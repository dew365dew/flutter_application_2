import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/response/customer_idx_get_res.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/config/config.dart';

class ProfilePage extends StatefulWidget {
  final int idx;
  const ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Customer> loadData;

  final fullnameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('ลบสมาชิก', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Customer>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("ไม่พบข้อมูล"));
          }

          final customer = snapshot.data!;

          fullnameCtrl.text = customer.fullname;
          phoneCtrl.text = customer.phone;
          emailCtrl.text = customer.email;
          imageCtrl.text = customer.image;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(imageCtrl.text),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: fullnameCtrl,
                  decoration: const InputDecoration(labelText: "ชื่อ-นามสกุล"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: "หมายเลขโทรศัพท์",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "อีเมล"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageCtrl,
                  decoration: const InputDecoration(labelText: "รูปภาพ (URL)"),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: updateCustomer,
                    child: const Text("บันทึกข้อมูล"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Customer> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    final data = jsonDecode(res.body);
    return Customer.fromJson(data);
  }

  Future<void> updateCustomer() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final body = {
      "fullname": fullnameCtrl.text,
      "phone": phoneCtrl.text,
      "email": emailCtrl.text,
      "image": imageCtrl.text,
    };

    var res = await http.put(
      Uri.parse('$url/customers/${widget.idx}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("บันทึกข้อมูลสำเร็จ")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("บันทึกข้อมูลไม่สำเร็จ: ${res.body}")),
      );
    }
  }

  Future<void> deleteCustomer() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final res = await http.delete(Uri.parse('$url/customers/${widget.idx}'));

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ลบสมาชิกสำเร็จ")));
      Navigator.pop(context); // กลับไปหน้าก่อนหน้า
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ลบสมาชิกไม่สำเร็จ: ${res.body}")));
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณแน่ใจว่าต้องการลบสมาชิกนี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteCustomer();
            },
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
