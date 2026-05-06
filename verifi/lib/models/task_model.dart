enum TaskStatus { pending, verified, rejected }

class Task {
  final String id;
  final String uid;
  final String title;
  final String? description;
  final DateTime deadline;
  final bool isVerifiable;
  final TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.uid,
    required this.title,
    this.description,
    required this.deadline,
    this.isVerifiable = true,
    this.status = TaskStatus.pending,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      uid: json['uid'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: DateTime.parse(json['deadline'] as String),
      isVerifiable: json['isVerifiable'] as bool,
      status: TaskStatus.values.byName(json['status'] as String? ?? 'pending'),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'isVerifiable': isVerifiable,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isVerifiable,
    TaskStatus? status,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isVerifiable: isVerifiable ?? this.isVerifiable,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
