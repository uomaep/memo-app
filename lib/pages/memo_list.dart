import 'dart:convert';

import 'package:app/model/memo_model.dart';
import 'package:app/pages/memo_write.dart';
import 'package:app/widgets/memo_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MemoList extends StatefulWidget {
  const MemoList({super.key});
  @override
  State<MemoList> createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  String url = "http://localhost:8080";
  late Future<List<Memo>> memos;
  late int memoCnt = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      memos = getMemos();
    });
  }

  Future<List<Memo>> getMemos() async {
    print("getMemos");
    var res = await http.get(Uri.parse("$url/memo"));
    if (res.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<Memo> memos = body.map((e) => Memo.fromJson(e)).toList();
      setState(() {
        memoCnt = memos.length;
      });
      return memos;
    } else {
      throw Exception("불러오는데 실패했습니다!");
    }
  }

  Future<void> deleteHandler(BuildContext context) async {
    var delList = [];
    memos.then((value) {
      for (var e in value) {
        {
          if (e.checked) delList.add(e.id);
        }
      }
    }).then((_) => {
          if (delList.isNotEmpty)
            {
              showDialog<void>(
                //다이얼로그 위젯 소환
                context: context,
                barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('제목'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        //List Body를 기준으로 Text 설정
                        children: const <Widget>[
                          Text('정말 삭제하시겠습니까?'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('확인'),
                        onPressed: () {
                          http
                              .delete(Uri.parse("$url/memo"),
                                  headers: {'content-type': 'application/json'},
                                  body: jsonEncode(delList))
                              .then((resp) => {
                                    if (resp.statusCode == 200)
                                      setState(() {
                                        memos = getMemos();
                                      })
                                  });
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('취소'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              )
            }
        });
  }

  void writeMemo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WritePage(
          notifyParent: () {
            setState(() {
              memos = getMemos();
            });
          },
        ),
      ),
    );
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
              onTap: () {
                deleteHandler(context);
              },
              child: Image.asset("assets/icons/trash.png"),
            ),
            Text(
              "$memoCnt개의 메모",
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
          child: FutureBuilder(
            future: memos,
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                throw Exception("불러오지 못했습니다.");
              } else {
                var list = snapshot.data;
                return ListView.separated(
                    itemBuilder: (context, index) => MemoCard(
                          list![index],
                          notifyParent: () {
                            setState(() {
                              memos = getMemos();
                            });
                          },
                        ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: list?.length ?? 0);
              }
            },
          ),
        ),
      ),
    );
  }
}
