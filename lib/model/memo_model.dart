class Memo {
  String? memoId;
  String memoTitle;
  String memoText;
  bool checked = false;

  Memo(this.memoId, this.memoTitle, this.memoText);

  Memo.fromJson(Map<String, dynamic> json)
      : memoId = json['memo_id'],
        memoTitle = json['memo_title'],
        memoText = json['memo_text'];

  Map<String, dynamic> toJson() => {
        'memo_id': memoId,
        'memo_title': memoTitle,
        'memo_text': memoText,
      };
}
