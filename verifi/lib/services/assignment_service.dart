import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/assignment_model.dart';
import '../models/message_model.dart';
import 'dart:typed_data';

class AssignmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Stream assignment where current user is verifier for today
  Stream<DailyAssignment?> watchTodayAsVerifier(String uid, String date) {
    return _firestore
        .collection('dailyAssignments')
        .where('verifierId', isEqualTo: uid)
        .where('date', isEqualTo: date)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isEmpty ? null : DailyAssignment.fromJson(snap.docs.first.data()));
  }

  // Stream assignment where current user is owner for today
  Stream<DailyAssignment?> watchTodayAsOwner(String uid, String date) {
    return _firestore
        .collection('dailyAssignments')
        .where('ownerId', isEqualTo: uid)
        .where('date', isEqualTo: date)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isEmpty ? null : DailyAssignment.fromJson(snap.docs.first.data()));
  }

  // Verify: mark tasks as verified and close assignment
  Future<void> verifyAssignment({
    required String assignmentDocId,
    required String ownerId,
    required List<String> taskIds,
    required String verifierId,
  }) async {
    final batch = _firestore.batch();

    for (final taskId in taskIds) {
      final taskRef = _firestore.collection('users').doc(ownerId).collection('tasks').doc(taskId);
      batch.update(taskRef, {'status': 'verified'});
    }

    final assignRef = _firestore.collection('dailyAssignments').doc(assignmentDocId);
    batch.update(assignRef, {
      'status': 'verified',
      'verifiedBy': verifierId,
      'closedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Reject: mark assignment rejected
  Future<void> rejectAssignment({
    required String assignmentDocId,
    required String verifierId,
    String? reason,
  }) async {
    final assignRef = _firestore.collection('dailyAssignments').doc(assignmentDocId);
    await assignRef.update({
      'status': 'rejected',
      'rejectedBy': verifierId,
      'rejectionReason': reason,
      'closedAt': FieldValue.serverTimestamp(),
    });
  }

  // Stream messages from assignment chat
  Stream<List<VerifiMessage>> watchMessages(String assignmentDocId) {
    return _firestore
        .collection('dailyAssignments')
        .doc(assignmentDocId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => VerifiMessage.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Send text message
  Future<void> sendMessage({
    required String assignmentDocId,
    required String senderUid,
    required String senderName,
    required String text,
  }) async {
    final msgRef = _firestore
        .collection('dailyAssignments')
        .doc(assignmentDocId)
        .collection('messages')
        .doc();

    await msgRef.set({
      'id': msgRef.id,
      'senderUid': senderUid,
      'senderName': senderName,
      'text': text,
      'imageUrl': null,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Upload image and send message with image
  Future<void> sendImageMessage({
    required String assignmentDocId,
    required String senderUid,
    required String senderName,
    required XFile imageFile,
    String? caption,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref('assignments/$assignmentDocId/images/$fileName');
      // Read file bytes for cross-platform support
      final Uint8List imageData = await imageFile.readAsBytes();
      await storageRef.putData(
        imageData,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final downloadUrl = await storageRef.getDownloadURL();

      final msgRef = _firestore
          .collection('dailyAssignments')
          .doc(assignmentDocId)
          .collection('messages')
          .doc();

      await msgRef.set({
        'id': msgRef.id,
        'senderUid': senderUid,
        'senderName': senderName,
        'text': caption ?? 'Shared an image',
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to send image: $e');
    }
  }
}
