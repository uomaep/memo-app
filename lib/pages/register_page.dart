import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String url = "http://localhost:8080";
  bool error1 = false;
  bool error2 = false;

  TextEditingController id_controller = TextEditingController();
  TextEditingController pw1_controller = TextEditingController();
  TextEditingController pw2_controller = TextEditingController();

  Widget inputField({
    required String labelText,
    required String hintText,
    required TextEditingController contoller,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: contoller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: Color(0xFF6524FF)),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Color(0xFF6524FF)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Color(0xFF6524FF)),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
      ),
    );
  }

  void registerHandler(BuildContext context) {
    var id = id_controller.text;
    var pw1 = pw1_controller.text;
    var pw2 = pw2_controller.text;
    if (id != "" && pw1 != "" && pw2 != "") {
      if (pw1.compareTo(pw2) != 0) {
        setState(() {
          error1 = false;
          error2 = true;
        });
        return;
      }
      var res = http
          .post(Uri.parse("$url/register"),
              headers: {'content-type': 'application/json'},
              body: jsonEncode({
                "id": id,
                "password": pw1,
              }))
          .then((res) => {if (res.statusCode == 200) Navigator.pop(context)});
    } else {
      setState(() {
        error1 = true;
        error2 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    "MEMO",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset("assets/images/main.png"),
                ],
              ),
            ),
            const SizedBox(height: 100),
            inputField(
              labelText: "ID",
              hintText: "아이디를 입력해주세요.",
              contoller: id_controller,
            ),
            const SizedBox(height: 10),
            inputField(
              labelText: "Password",
              hintText: "비밀번호를 입력해주세요.",
              contoller: pw1_controller,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 10),
            inputField(
              labelText: "Password Confirm",
              hintText: "비밀번호를 한 번더 입력해주세요.",
              contoller: pw2_controller,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            if (error1)
              const Text(
                "아이디와 비밀번호를 모두 입력해주세요.",
                style: TextStyle(color: Colors.red),
              ),
            if (error2)
              const Text(
                "비밀번호가 같지 않습니다.",
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 37),
            GestureDetector(
              onTap: () {
                registerHandler(context);
              },
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFF6524FF),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6524FF).withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
