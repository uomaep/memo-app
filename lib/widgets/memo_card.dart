import 'package:app/pages/memo_page.dart';
import 'package:flutter/material.dart';

import '../model/memo_model.dart';

class MemoCard extends StatefulWidget {
  late Memo memo;
  int userNo;
  MemoCard(
    this.memo, {
    super.key,
    required this.notifyParent,
    required this.userNo,
  });

  final Function notifyParent;

  @override
  State<MemoCard> createState() => _MemoCardState();
}

class _MemoCardState extends State<MemoCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: const Color(0xFFDBDBDB),
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                widget.memo.checked = !widget.memo.checked;
              });
            },
            child: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                "assets/icons/${widget.memo.checked ? "checked.png" : "unchecked.png"}",
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoPage(
                    widget.memo,
                    notifyParent: widget.notifyParent,
                    userNo: widget.userNo,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.memo.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.memo.subTitle != "")
                  Text(
                    widget.memo.subTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFF767676),
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
