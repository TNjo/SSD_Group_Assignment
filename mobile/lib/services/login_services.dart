import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/alert_services.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AlertService _alertService = AlertService();
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      // Handle login errors (e.g., invalid credentials)
      print('Error during login: $e');
      return null;
    }
  }

  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        return userSnapshot.get('role');
      } else {
        return "Unknown";
      }
    } catch (e) {
      // Handle errors in fetching user role
      print('Error fetching user role: $e');
      return "Unknown";
    }
  }
  Future<void> handleLogin(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  final String email = emailController.text;
  final String password = passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    _alertService.showAlertDialog(context, 'Validation Error', 'Email and password are required.');
    return;
  }

  if (!_isEmailValid(email)) {
    _alertService.showAlertDialog(context, 'Validation Error', 'Invalid email format.');
    return;
  }

  User? user = await signInWithEmailAndPassword(email, password);

  if (user != null) {
    String uid = user.uid;
    String userRole = await getUserRole(uid);

    if (userRole == "site_manager") {
      Navigator.pushNamed(context, '/sm_navbar',
          arguments: {'email': email, 'password': password, 'role': userRole, 'uid': uid});
    } else if (userRole == "supplier") {
      Navigator.pushNamed(context, '/sp_navbar',
          arguments: {'email': email, 'password': password, 'role': userRole, 'uid': uid});
    }

    emailController.clear();
    passwordController.clear();
  } else {
    // No user found, display an alert
    _alertService.showAlertDialog(context, 'Login Error', 'No user found with the provided credentials.');
  }
}


  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }
}


