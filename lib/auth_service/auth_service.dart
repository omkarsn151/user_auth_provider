import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Utility class for centralized error handling
class AuthErrorHandler {
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-not-found':
      case 'wrong-password': // Grouping wrong email and password cases
        return 'Wrong password or email. Please try again.';
      case 'email-already-in-use':
        return 'The email is already in use.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is disabled.';
      case 'weak-password':
        return 'The password is too weak. Please enter a stronger password.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  // Stores the data
  Future<void> _storeUserData(String uid, String name, String phone) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'phone': phone,
      'email': _auth.currentUser?.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Error handling
  String? _handleAuthError(FirebaseAuthException e) {
    if (kDebugMode) {
      print('Auth Error: ${e.message}');
    }
    return AuthErrorHandler.getErrorMessage(e.code);
  }

  // Sign Up
  Future<String?> signUp(
      String email, String password, String name, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      User? user = result.user;

      await _storeUserData(user!.uid, name, phone);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    }
  }

  // // Sign In
  // Future<String?> signIn(String email, String password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(
  //         email: email.trim(), password: password.trim());
  //     notifyListeners();
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return _handleAuthError(e);
  //   }
  // }


  // Sign In
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      // Debugging: print the error code and message
      if (kDebugMode) {
        print('SignIn Error: ${e.code} - ${e.message}');
      }
      return _handleAuthError(e);
    } catch (e) {
      // Handling unexpected errors
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return 'An unexpected error occurred. Please try again later.';
    }
  }


  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Delete account
  Future<String?> deleteAccount(String email, String password) async {
    try {
      User? user = _auth.currentUser;

      // Reauthenticate the user
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email.trim(),
          password: password.trim(),
        );

        await user.reauthenticateWithCredential(credential);

        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete user account
        await user.delete();

        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    }
  }

  // Retrieving data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
