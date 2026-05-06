class DailyAssignment {
  final String uid;
  final String date; // YYYY-MM-DD
  final String verifyingUserId;
  final String verifyingUserName;
  final List<String> taskIds;

  DailyAssignment({
    required this.uid,
    required this.date,
    required this.verifyingUserId,
    required this.verifyingUserName,
    required this.taskIds,
  });

  factory DailyAssignment.fromJson(Map<String, dynamic> json) {
    return DailyAssignment(
      uid: json['uid'] as String,
      date: json['date'] as String,
      verifyingUserId: json['verifyingUserId'] as String,
      verifyingUserName: json['verifyingUserName'] as String,
      taskIds: List<String>.from(json['taskIds'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'date': date,
      'verifyingUserId': verifyingUserId,
      'verifyingUserName': verifyingUserName,
      'taskIds': taskIds,
    };
  }
}
