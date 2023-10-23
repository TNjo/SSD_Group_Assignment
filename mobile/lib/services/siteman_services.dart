import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SiteManagerServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> fetchSiteManagerDetails(User user, dynamic Function(String, String, String, String) onDetailsFetched) async {
  await _firestore
      .collection('siteManagers')
      .where('userId', isEqualTo: user.uid)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs[0];
      final managerName = userDoc['managerName'] ?? '';
      final companyName = userDoc['companyName'] ?? '';
      final siteName = userDoc['siteName'] ?? '';
      final siteNumber = userDoc['siteNumber'] ?? '';

      onDetailsFetched(managerName, companyName, siteName, siteNumber);
    }
  });
}

Future<void> initializeSiteManagerData(List<String> selectedItems, Function(String, String, String, String) onDetailsFetched) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      
      // Query the 'siteManagers' collection to find the document with the matching 'userId'
      final querySnapshot = await firestore
          .collection('siteManagers')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs[0];
        onDetailsFetched(
          userDoc['managerName'] ?? '',
          userDoc['companyName'] ?? '',
          userDoc['siteName'] ?? '',
          userDoc['siteNumber'] ?? '',
        );
      }
    }
  }
}

