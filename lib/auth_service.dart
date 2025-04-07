import 'package:logger/logger.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger(); // Instancia del logger.

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      switch (e.code) {
        case 'user-not-found':
          _logger.e('No user found for that email.');
          throw Exception('No user found for that email.');
        case 'wrong-password':
          _logger.e('Wrong password provided.');
          throw Exception('Wrong password provided.');
        default:
          _logger.e('An unexpected error occurred: ${e.message}');
          throw Exception('An unexpected error occurred: ${e.message}');
      }
    } catch (e) {
      // Handle any other exceptions
      _logger.e('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      switch (e.code) {
        case 'email-already-in-use':
          _logger.e('The email address is already in use.');
          throw Exception('The email address is already in use.');
        case 'weak-password':
          _logger.e('The password provided is too weak.');
          throw Exception('The password provided is too weak.');
        default:
          _logger.e('An unexpected error occurred: ${e.message}');
          throw Exception('An unexpected error occurred: ${e.message}');
      }
    } catch (e) {
      // Handle any other exceptions
      _logger.e('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _logger.i('User signed out successfully.');
    } catch (e) {
      _logger.e('Error signing out: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
