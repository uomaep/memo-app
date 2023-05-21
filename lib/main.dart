import 'package:app/pages/memo_list.dart';
import 'package:flutter/material.dart';

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
  TextEditingController id_controller = TextEditingController();
  TextEditingController pw_controller = TextEditingController();

  Widget inputField({
    required String labelText,
    required String hintText,
    required TextEditingController contoller,
  }) {
    return TextField(
      controller: contoller,
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

  void loginHandler(BuildContext context) {
    if (id_controller.text != "" && pw_controller.text != "") {
      print("id: ${id_controller.text}");
      print("pw: ${pw_controller.text}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MemoList()),
      );
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}
