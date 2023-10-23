import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, Object>>?> fetchSupplierItems(String userId) async {
    final querySnapshot = await _firestore
        .collection('suppliers')
        .where('userId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs[0].data() as Map<String, dynamic>;

      if (userDoc.containsKey('items') && userDoc['items'] is List) {
        final itemsFromFirestore = userDoc['items'] as List;

        final separatedItems = itemsFromFirestore.map((item) {
          final itemName = item['itemName'] as String;
          final price = item['price'] as int;
          final quantity = item['quantity'] as int;
          final description = item['description'] as String;

          return {
            'itemName': itemName,
            'price': price,
            'quantity': quantity,
            'description': description,
          };
        }).toList();

        return separatedItems;
      }
    }
    return null;
  }

  Future<void> updateItem(String userId, Map<String, Object> updatedItem, int itemIndex) async {
    final querySnapshot = await _firestore
        .collection('suppliers')
        .where('userId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userDocRef = querySnapshot.docs[0].reference;
      List<dynamic> currentItems = querySnapshot.docs[0]['items'];

      // Update the desired item within the array
      currentItems[itemIndex] = updatedItem;

      // Update the entire 'items' array with the modified array
      userDocRef.update({'items': currentItems});
    }
  }

  Future<void> deleteItem(String userId, int itemIndex) async {
    final querySnapshot = await _firestore
        .collection('suppliers')
        .where('userId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userDocRef = querySnapshot.docs[0].reference;
      List<dynamic> currentItems = querySnapshot.docs[0]['items'];

      // Remove the item at the specified index
      currentItems.removeAt(itemIndex);

      // Update the entire 'items' array with the modified array
      userDocRef.update({'items': currentItems});
    }
  }

  Future<void> addItems(
    String userId,
    List<Map<String, dynamic>> updatedItems,
  ) async {
    final userDocsQuery = _firestore.collection('suppliers').where('userId', isEqualTo: userId);
    final userDocsSnapshot = await userDocsQuery.get();

    if (userDocsSnapshot.docs.isNotEmpty) {
      final userDocRef = userDocsSnapshot.docs[0].reference;

      await userDocRef.update({
        'items': FieldValue.arrayUnion(updatedItems),
      });
    } else {
      print('Error: Document for the user does not exist.');
    }
  }
}
