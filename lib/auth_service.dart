import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Wrong password provided.');
        default:
          throw Exception('An unexpected error occurred: ${e.message}');
      }
    } catch (e) {
      // Handle any other exceptions
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
          throw Exception('The email address is already in use.');
        case 'weak-password':
          throw Exception('The password provided is too weak.');
        default:
          throw Exception('An unexpected error occurred: ${e.message}');
      }
    } catch (e) {
      // Handle any other exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
