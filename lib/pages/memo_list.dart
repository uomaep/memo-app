import 'package:app/model/memo_model.dart';
import 'package:app/pages/memo_write.dart';
import 'package:app/widgets/memo_card.dart';
import 'package:flutter/material.dart';

class MemoList extends StatefulWidget {
  const MemoList({super.key});

  @override
  State<MemoList> createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  late List<Memo> memos;

  @override
  void initState() {
    super.initState();
    memos = [
      for (int i = 1; i < 5; i++) Memo(null, "title$i", "content$i"),
    ];
  }

  void deleteMemo() {
    setState(() {
      memos = memos.where((e) => !e.checked).toList();
    });
  }

  void writeMemo(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WritePage(memos)));
  }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        "메모",
        style: TextStyle(
          color: Color(0xFF6524FF),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      height: 88,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: deleteMemo,
              child: Image.asset("assets/icons/trash.png"),
            ),
            Text(
              "${memos.length}개의 메모",
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6524FF),
              ),
            ),
            GestureDetector(
              onTap: () {
                writeMemo(context);
              },
              child: Image.asset("assets/icons/write.png"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: _appbar(),
        bottomNavigationBar: _bottomAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView.separated(
              itemBuilder: (context, index) => MemoCard(memos[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: memos.length),
        ),
      ),
    );
  }
}
