import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a method to get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
