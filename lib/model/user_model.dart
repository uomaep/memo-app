class User {
  final String userId;

  User(this.userId);

  User.fromJson(Map<String, dynamic> json) : userId = json['user_id'];
}
