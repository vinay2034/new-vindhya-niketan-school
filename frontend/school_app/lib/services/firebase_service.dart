import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore methods
  Future<void> createUserProfile(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        ...userData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to create user profile: $e';
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      throw 'Failed to get user profile: $e';
    }
  }

  // Error handling
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        default:
          return 'Authentication failed: ${error.message}';
      }
    }
    return 'Authentication failed: $error';
  }

  // Role-specific methods
  Future<void> createTeacher(Map<String, dynamic> teacherData) async {
    try {
      await _firestore.collection('teachers').add({
        ...teacherData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to create teacher: $e';
    }
  }

  Future<void> createParent(Map<String, dynamic> parentData) async {
    try {
      await _firestore.collection('parents').add({
        ...parentData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to create parent: $e';
    }
  }

  // Student management
  Future<void> createStudent(Map<String, dynamic> studentData) async {
    try {
      await _firestore.collection('students').add({
        ...studentData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to create student: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsForParent(String parentId) async {
    try {
      final snapshot = await _firestore
          .collection('students')
          .where('parentId', isEqualTo: parentId)
          .get();
      
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw 'Failed to get students: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsForTeacher(String teacherId) async {
    try {
      final snapshot = await _firestore
          .collection('students')
          .where('teacherId', isEqualTo: teacherId)
          .get();
      
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw 'Failed to get students: $e';
    }
  }
}