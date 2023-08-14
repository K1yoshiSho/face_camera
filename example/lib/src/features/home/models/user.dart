class User {
  final String? name;
  final String? userId;
  User({
    this.name,
    this.userId,
  });

  factory User.fromJson({required Map<String, dynamic> json}) {
    return User(
      name: json['full_name'] as String?,
      userId: json['userId'] as String?,
    );
  }
}
