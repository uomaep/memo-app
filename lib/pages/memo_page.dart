import 'package:flutter/material.dart';

import '../model/memo_model.dart';

class MemoPage extends StatefulWidget {
  Memo memo;
  MemoPage(this.memo, {super.key});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text =
        "${widget.memo.memoTitle}\n${widget.memo.memoText}";
  }

  void writeHandler() {
    String text = _textEditingController.text;
    print("title: ${text.split('\n')[0]}");
    print(text);
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
              writeHandler();
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
