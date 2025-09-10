import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/request/customer_login_post_req.dart';
import 'package:flutter_application_2/model/response/customer_login_post_res.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/register.dart';
import 'package:flutter_application_2/pages/showtrip.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  String phoneNo = '';
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  String url = '';

  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  Object? get data => null;

  //Object? get data => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),

      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () {},
              child: Image.asset('assets/images/logo.png'),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'หมายเลขโทรศัพท์',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      TextField(
                        controller: phoneNoCtl,

                        //  onChanged: (value) {
                        //   phoneNo = value;
                        //  log(value);
                        // },
                        keyboardType: TextInputType.phone,

                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('รหัสผ่าน', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  TextField(
                    controller: passwordCtl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: register,

                    child: const Text('ลงทะเบียนใหม่'),
                  ),
                  FilledButton(
                    onPressed: login,
                    child: const Text('เข้าสู้ระบบ'),
                  ),
                ],
              ),
            ),
            Text(text),
          ],
        ),
      ),
    );
  }

  void register() {
    log('This is the register button');
    text = 'Hello World!!!';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
  /*
  void login() {
    // log(phoneNoCtl.text);
    setState(() {
      number++;
      // text = 'Login time: ' + number.toString() + phoneNoCtl.text;
    });
    /*  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShowTripPage()),
    );
  */
  } */

  void login() {
    String phone = phoneNoCtl.text.trim();
    String password = passwordCtl.text.trim();

    // ตรวจสอบข้อมูลก่อนส่ง
    if (phone.isEmpty || password.isEmpty) {
      setState(() {
        text = 'กรุณากรอกเบอร์โทรศัพท์และรหัสผ่าน';
      });
      return;
    }

    if (phone.length != 10 || !phone.startsWith('0')) {
      setState(() {
        text = 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง (10 หลัก)';
      });
      return;
    }

    // สร้าง request และส่งไปยังเซิร์ฟเวอร์
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phone,
      password: password,
    );

    http
        .post(
          Uri.parse("$url/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);

          // แปลง JSON เป็น object
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);

          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          log(customerLoginPostResponse.customer.idx.toString());
          // ไปยังหน้า ShowTripPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShowTripPage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
          setState(() {
            text = 'เข้าสู่ระบบไม่สำเร็จ: ใส่รหัส ไม่เบอร์ ถูก $error';
          });
        });
  }
}
