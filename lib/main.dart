import 'dart:convert';

import 'package:app/pages/memo_list.dart';
import 'package:app/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'uomaep - memo',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String url = "http://localhost:8080";
  TextEditingController id_controller = TextEditingController();
  TextEditingController pw_controller = TextEditingController();
  bool loginError = false;
  bool loginError2 = false;
  final _storage = const FlutterSecureStorage();

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

  void loginHandler(BuildContext context) async {
    var id = id_controller.text;
    var pw = pw_controller.text;
    if (id != "" && pw != "") {
      var res = await http.post(
        Uri.parse("$url/login"),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({"id": id, "password": pw}),
      );

      if (res.statusCode == 200) {
        var userNo = jsonDecode(res.body);

        if (userNo == -1) {
          setState(() {
            loginError = true;
            loginError2 = false;
          });
          return;
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MemoList(userNo: userNo)));
          setState(() {
            loginError = false;
            loginError2 = false;
          });
        }
      }
    } else {
      setState(() {
        loginError = false;
        loginError2 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
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
                contoller: pw_controller,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              if (loginError)
                const Text(
                  "아이디와 비밀번호가 맞지 않습니다.",
                  style: TextStyle(color: Colors.red),
                ),
              if (loginError2)
                const Text(
                  "아이디와 비밀번호를 입력해주세요",
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 37),
              GestureDetector(
                onTap: () {
                  loginHandler(context);
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
                      "로그인",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Text(
                    "계정이 없으세요?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    },
                    child: const Text(
                      "회원가입",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
