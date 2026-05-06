class VerifiUser {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final int tasksCount;

  VerifiUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.tasksCount = 0,
  });

  /// Alias for displayName for convenience
  String get name => displayName;

  factory VerifiUser.fromJson(Map<String, dynamic> json) {
    return VerifiUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tasksCount: json['tasksCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
      'tasksCount': tasksCount,
    };
  }
}
