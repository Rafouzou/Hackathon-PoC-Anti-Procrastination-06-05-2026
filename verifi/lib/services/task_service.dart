import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create task
  Future<Task> createTask({
    required String uid,
    required String title,
    String? description,
    required DateTime deadline,
    required bool isVerifiable,
  }) async {
    try {
      final taskRef = _firestore.collection('users').doc(uid).collection('tasks').doc();
      final now = DateTime.now();

      final task = Task(
        id: taskRef.id,
        uid: uid,
        title: title,
        description: description,
        deadline: deadline,
        isVerifiable: isVerifiable,
        createdAt: now,
      );

      await taskRef.set(task.toJson());
      return task;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Get all tasks for user
  Stream<List<Task>> getUserTasks(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('deadline', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
        });
  }

  // Get single task
  Future<Task> getTask(String uid, String taskId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .get();

      if (!doc.exists) {
        throw Exception('Task not found');
      }
      return Task.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  // Update task
  Future<void> updateTask(String uid, Task task) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task.id)
          .update(task.toJson());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Update task status
  Future<void> updateTaskStatus(
    String uid,
    String taskId,
    TaskStatus status,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .update({'status': status.name});
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String uid, String taskId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Get verifiable tasks for user
  Future<List<Task>> getVerifiableTasks(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .where('isVerifiable', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get verifiable tasks: $e');
    }
  }
}
