import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class OrderServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPendingOrderStream(Map<String, dynamic> userData) {
    return _firestore.collection('orders').snapshots();
  }

  Stream<QuerySnapshot> getApprovedOrdersStream(Map<String, dynamic> userData) {
    return FirebaseFirestore.instance.collection('orders').snapshots();
  }

  Future<List<Map<dynamic, dynamic>>?> fetchOrdersForCurrentSP() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userOrdersCollection = _firestore.collection('orders');
      final userOrdersQuery = userOrdersCollection.where(
        'supplier',
        isEqualTo: currentUser.email,
      );

      try {
        final querySnapshot = await userOrdersQuery.get();
        final orders = querySnapshot.docs;

        List<Map<dynamic, dynamic>> orderDataList = [];

        for (var order in orders) {
          final int status = order['status'];
          final double price = order['totalPrice'];
          final List<dynamic> items = order['items'] ?? [];

          List<Map<String, dynamic>> itemsAsMap = items.map((item) {
            return {
              'name': item['name'] ?? '',
              'quantity': item['quantity'] ?? 0,
              'price': item['price'] ?? 0.0,
            };
          }).toList();

          Map<dynamic, dynamic> orderData = {
            'orderId': order['orderid'] ?? '',
            'constructionSite': order['constructionSite'] ?? '',
            'date': order['date']?.toDate()?.toString() ?? '',
            'items': itemsAsMap,
            'sitemanager': order['sitemanager'] ?? '',
            'status': status, // Set a default value if 'status' is missing
            'totalPrice':
                price, // Set a default value if 'totalPrice' is missing
          };

          orderDataList.add(orderData);
        }

        return orderDataList;
      } catch (e) {
        print("Error fetching orders: $e");
        return null;
      }
    }
    return null;
}

Future<void> placeOrder(
    String siteName,
    String managerName,
    String userId,
    List<ItemData> items,
  ) async {
    final firestore = FirebaseFirestore.instance;

    final orderData = {
      'constructionSite': siteName,
      'date': Timestamp.now(),
      'items': items.map((item) {
        return {
          'name': item.name,
          'quantity': item.quantity,
        };
      }).toList(),
      'orderid': generateOrderId(),
      'sitemanager': managerName,
      'sitemanagerId': userId,
      'status': 1,
      'supplier': '',
      'totalPrice': 0,
    };

    await firestore.collection('orders').add(orderData);
  }

  String generateOrderId() {
    // Generate a unique order ID based on the current timestamp and a random number
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (1000 + Random().nextInt(9000))
        .toString(); // Generates a 4-digit random number
    return '$timestamp$random';
  }

    Future<void> sendNewQuotation(String orderId, Map<String, double> itemPrices) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final firestore = FirebaseFirestore.instance;

      final userOrdersCollection = firestore.collection('orders');
      final userOrdersQuery = userOrdersCollection.where('orderid', isEqualTo: orderId);

      try {
        final querySnapshot = await userOrdersQuery.get();

        if (querySnapshot.docs.isNotEmpty) {
          final orderDocument = querySnapshot.docs.first;
          final orderData = orderDocument.data() as Map<String, dynamic>;

          final updatedItems = <Map<String, dynamic>>[];
          double totalPrice = 0.0;
          for (var item in orderData['items'] as List) {
            final itemName = item['name'];
            final updatedPrice = itemPrices[itemName];
            final updatedItem = {
              'name': itemName,
              'quantity': item['quantity'],
              'price': updatedPrice,
            };
            updatedItems.add(updatedItem);
            totalPrice += (updatedPrice ?? 0) * (item['quantity'] ?? 0);
          }

          await orderDocument.reference.update({
            'items': updatedItems,
            'totalPrice': totalPrice,
            'status': 8,
          });
        }
      } catch (e) {
        print('Error sending quotation: $e');
      }
    }
  }

  Future<void> rejectOrder(String orderId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final firestore = FirebaseFirestore.instance;
      final userOrdersCollection = firestore.collection('orders');
      final userOrdersQuery = userOrdersCollection.where('orderid', isEqualTo: orderId);

      try {
        final querySnapshot = await userOrdersQuery.get();

        if (querySnapshot.docs.isNotEmpty) {
          final orderDocument = querySnapshot.docs.first;
          await orderDocument.reference.update({'status': 6});
        }
      } catch (e) {
        print('Error rejecting the order: $e');
      }
    }
  }

  Future<void> acceptOrder(String orderId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final firestore = FirebaseFirestore.instance;
      final userOrdersCollection = firestore.collection('orders');
      final userOrdersQuery = userOrdersCollection.where('orderid', isEqualTo: orderId);

      try {
        final querySnapshot = await userOrdersQuery.get();

        if (querySnapshot.docs.isNotEmpty) {
          final orderDocument = querySnapshot.docs.first;
          await orderDocument.reference.update({'status': 5});
        }
      } catch (e) {
        print('Error accepting the order: $e');
      }
    }
  }
  // Add more order-related functions here as needed
}

class ItemData {
  String name;
  int quantity;

  ItemData({required this.name, required this.quantity});
}
