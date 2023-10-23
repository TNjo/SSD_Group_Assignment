import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> updateSMProfile(String email, String password, String managerName, String contact, String companyName, String siteName, String siteNumber) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        final userDocsQuery = _firestore.collection('siteManagers').where('userId', isEqualTo: userId);

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
        } else {
          print('Error: Document for user does not exist.');
        }
      } catch (e) {
        print('Error during profile update: $e');
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
    String email,
    String password,
    String supplierName,
    String contact,
    String address,
  ) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        final userDocsQuery = _firestore.collection('suppliers').where('userId', isEqualTo: userId);

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
        } else {
          print('Error: Document for user does not exist.');
        }
      } catch (e) {
        print('Error during profile update: $e');
      }
    }
  }
}

