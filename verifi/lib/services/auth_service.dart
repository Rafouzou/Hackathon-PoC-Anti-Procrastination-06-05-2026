import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _emailFromUsername(String username) {
    final normalized = username.trim().toLowerCase();
    return '$normalized@verifi.local';
  }

  // Get current user stream
  Stream<VerifiUser?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await getUser(user.uid);
    });
  }

  // Get current user
  VerifiUser? get currentUser {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return VerifiUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? 'Unknown',
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  // Sign up with email and password
  Future<VerifiUser> signUp({
    required String username,
    required String password,
  }) async {
    try {
      final email = _emailFromUsername(username);
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(username.trim());

      final user = VerifiUser(
        uid: userCredential.user!.uid,
        email: email,
        displayName: username.trim(),
        createdAt: DateTime.now(),
      );

      // Save user to Firestore
      await _firestore.collection('users').doc(user.uid).set(user.toJson());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in with email and password
  Future<VerifiUser> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final email = _emailFromUsername(username);
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await getUser(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get user by UID
  Future<VerifiUser> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return VerifiUser.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Handle Firebase Auth errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
