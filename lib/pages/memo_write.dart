import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WritePage extends StatefulWidget {
  int userNo;
  WritePage({
    super.key,
    required this.notifyParent,
    required this.userNo,
  });

  final Function notifyParent;

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String url = "http://localhost:8080";

  final TextEditingController _textEditingController = TextEditingController();

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
            onTap: () async {
              String content = _textEditingController.text;
              var resp = await http.post(
                Uri.parse("$url/memo"),
                headers: {'content-type': 'application/json'},
                body: jsonEncode({
                  'certno': widget.userNo,
                  'content': content,
                }),
              );
              if (resp.statusCode == 200) widget.notifyParent();
              Navigator.pop(context);
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
