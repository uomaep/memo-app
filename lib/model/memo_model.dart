class Memo {
  int? id;
  late String content;
  late String title = "";
  late String subTitle = "";
  bool checked = false;

  Memo(this.id, this.content);

  Memo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    title = content.split("\n")[0];
    if (content.split("\n").length > 1) {
      subTitle = content.split("\n")[1];
    }
  }
}
