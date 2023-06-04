import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WritePage extends StatelessWidget {
  String url = "http://localhost:8080";
  WritePage({super.key});

  final TextEditingController _textEditingController = TextEditingController();

  void writeHandler(BuildContext context) {
    String content = _textEditingController.text;
    http
        .post(Uri.parse("$url/memo"),
            headers: {'content-type': 'application/json'},
            body: jsonEncode({
              "content": content,
            }))
        .then((_) => {Navigator.pop(context)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF6524FF),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              writeHandler(context);
            },
            child: Image.asset("assets/icons/checked.png"),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: TextField(
          controller: _textEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorColor: const Color(0xFF6524FF),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: 22,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
