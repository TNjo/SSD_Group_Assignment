import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/alert_services.dart';

class SignupService {
  final AlertService _alertService = AlertService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late BuildContext
      context; // You'll need to set this context from your widget.

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool isStrongPassword(String password) {
    // Check for password strength, e.g., at least 8 characters, contains letters, numbers, and special characters.
    return password.length >= 8 &&
        password.contains(RegExp(r'[a-zA-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  }

  bool arePasswordsMatching(String password, String reEnteredPassword) {
    return password == reEnteredPassword;
  }

  Future<void> signUp(
  BuildContext context,
  String email,
  String password,
  String reEnteredPassword,
  String selectedOption,
) async {
  if (email.isEmpty || password.isEmpty) {
    _alertService.showAlertDialog(context, 'Error', 'Email and password are required.');
    return;
  }

  if (!isValidEmail(email)) {
    _alertService.showAlertDialog(context, 'Error', 'Invalid email format.');
    return;
  }

  if (!isStrongPassword(password)) {
    _alertService.showAlertDialog(context, 'Error',
        'Weak password. Password should be at least 8 characters long and contain letters, numbers, and special characters.');
    return;
  }

  if (!arePasswordsMatching(password, reEnteredPassword)) {
      _alertService.showAlertDialog(context, 'Error', 'Passwords do not match.');
      return;
    }
 
  if (selectedOption != "Site Manager" && selectedOption != "Supplier") {
    _alertService.showAlertDialog(context, 'Error', 'Invalid user role selected.');
    return;
  }

  try {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      String userId = userCredential.user!.uid;
      String userRole =
          selectedOption == "Site Manager" ? "site_manager" : "supplier";

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'role': userRole,
        // Add other user data fields here...
      });

      if (userRole == "site_manager") {
        await FirebaseFirestore.instance.collection('siteManagers').add({
          'userId': userId,
          'email': email,
          'password': password,
          // Add other site manager data fields here...
        });
      } else if (userRole == "supplier") {
        await FirebaseFirestore.instance.collection('suppliers').add({
          'userId': userId,
          'email': email,
          'password': password,
          // Add other supplier data fields here...
        });
      }
    }
    _alertService.showAlertDialog(context, 'Success', 'Signup Successfull.');
    Navigator.of(context).pushNamed('/login');
  } catch (e) {
    print('Error during sign-up: $e');
    _alertService.showAlertDialog(context, 'Error', 'Error during sign-up.');
  }
}

}
