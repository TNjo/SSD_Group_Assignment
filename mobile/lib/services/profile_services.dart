import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchSMProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;

      final querySnapshot = await _firestore
          .collection('siteManagers')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs[0].data() as Map<String, dynamic>;
        return userDoc;
      }
    }
    return {};
  }

  Future<void> _showCustomDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateSMProfile(
    BuildContext context,
    String email,
    String password,
    String managerName,
    String contact,
    String companyName,
    String siteName,
    String siteNumber,
  ) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;

      // Add validation for empty fields and contact number
      if (email.isEmpty ||
          password.isEmpty ||
          managerName.isEmpty ||
          contact.isEmpty ||
          companyName.isEmpty ||
          siteName.isEmpty ||
          siteNumber.isEmpty) {
        _showCustomDialog(context, 'Error', 'All fields must be filled.');
      } else if (contact.length != 10) {
        _showCustomDialog(
            context, 'Error', 'Contact number must contain exactly 10 digits.');
      } else {
        try {
          final userDocsQuery = _firestore
              .collection('siteManagers')
              .where('userId', isEqualTo: userId);

          final userDocsSnapshot = await userDocsQuery.get();

          if (userDocsSnapshot.docs.isNotEmpty) {
            final userDocRef = userDocsSnapshot.docs[0].reference;

            await userDocRef.update({
              'email': email,
              'password': password,
              'managerName': managerName,
              'contact': contact,
              'companyName': companyName,
              'siteName': siteName,
              'siteNumber': siteNumber,
            });
            // Show success message
            _showCustomDialog(context, 'Success', 'Profile updated successfully.');
          } else {
            print('Error: Document for user does not exist.');
          }
        } catch (e) {
          print('Error during profile update: $e');

          // Show error message
          _showCustomDialog(context, 'Error', 'Failed to update profile.');
        }
      }
    }
  }

  Future<Map<String, dynamic>> fetchSPProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;

      final querySnapshot = await _firestore
          .collection('suppliers')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs[0].data() as Map<String, dynamic>;
        return userDoc;
      }
    }
    return {};
  }

  Future<void> updateSPProfile(
    BuildContext context,
    String email,
    String password,
    String supplierName,
    String contact,
    String address,
  ) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;

      // Add validation for empty fields and contact number
      if (email.isEmpty ||
          password.isEmpty ||
          supplierName.isEmpty ||
          contact.isEmpty ||
          address.isEmpty) {
        _showCustomDialog(context, 'Error', 'All fields must be filled.');
      } else if (contact.length != 10) {
        _showCustomDialog(
            context, 'Error', 'Contact number must contain exactly 10 digits.');
      } else {
        try {
          final userDocsQuery = _firestore
              .collection('suppliers')
              .where('userId', isEqualTo: userId);

          final userDocsSnapshot = await userDocsQuery.get();

          if (userDocsSnapshot.docs.isNotEmpty) {
            final userDocRef = userDocsSnapshot.docs[0].reference;

            await userDocRef.update({
              'email': email,
              'password': password,
              'supplierName': supplierName,
              'contact': contact,
              'address': address,
            });
            // Show success message
            _showCustomDialog(
                context, 'Success', 'Profile updated successfully.');
          } else {
            print('Error: Document for user does not exist.');
          }
        } catch (e) {
          print('Error during profile update: $e');
          // Show error message
          _showCustomDialog(context, 'Error', 'Failed to update profile.');
        }
      }
    }
  }
}
