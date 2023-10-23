import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(String email, String password, String selectedOption) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        String userRole = selectedOption == "Site Manager" ? "site_manager" : "supplier";

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
    } catch (e) {
      // Handle sign-up errors (e.g., email is already in use)
      print('Error during sign-up: $e');
    }
  }
}
