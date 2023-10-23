import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import the fluttertoast package
import 'package:mobile/components/sm_itemlist.dart';

class SMCartPage extends StatefulWidget {
  final List<String> selectedItems;
  final Map<String, dynamic> userData;

  SMCartPage({Key? key, required this.selectedItems, required this.userData})
      : super(key: key);

  @override
  State<SMCartPage> createState() => _SMCartState();
}

class _SMCartState extends State<SMCartPage> {
  String managerName = '';
  String companyName = '';
  String siteName = '';
  String siteNumber = '';

  String generateOrderId() {
    // Generate a unique order ID based on the current timestamp and a random number
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (1000 + Random().nextInt(9000))
        .toString(); // Generates a 4-digit random number
    return '$timestamp$random';
  }

  bool _showHomePage = false;

  void _toggleHomePage() {
    setState(() {
      _showHomePage = !_showHomePage;
    });
  }

  List<ItemData> itemDataList = [];

  void placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;

      // Construct the order data
      final orderData = {
        'constructionSite': siteName, // Replace with your data source
        'date': Timestamp.now(),
        'items': itemDataList.map((item) {
          return {
            'name': item.name,
            'quantity': item.quantity,
          };
        }).toList(),
        'orderid': generateOrderId(), // Implement this method
        'sitemanager': managerName, // Replace with your data source
        'sitemanagerId': widget.userData['uid'],
        'status': 1, // Pending (1)
        'supplier': '', // Replace with your data source
        'totalPrice': 0, // Implement this method
      };

      // Add the order to the Firestore "orders" collection
      firestore.collection('orders').add(orderData).then((docRef) {
        print('Order placed with ID: ${docRef.id}');
        // Clear the itemDataList or update it as needed
        itemDataList.clear();

        // Show a toast message for successful order placement
        Fluttertoast.showToast(
          msg: 'Order added successfully!',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_LONG,
        );
      }).catchError((error) {
        print('Error placing order: $error');
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize itemDataList based on selectedItems
    for (String itemName in widget.selectedItems) {
      itemDataList.add(ItemData(name: itemName, quantity: 1));
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;

      // Query the 'siteManagers' collection to find the document with the matching 'userId'
      firestore
          .collection('siteManagers')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          final userDoc = querySnapshot.docs[0];
          setState(() {
            managerName = userDoc['managerName'] ?? '';
            companyName = userDoc['companyName'] ?? '';
            siteName = userDoc['siteName'] ?? '';
            siteNumber = userDoc['siteNumber'] ?? '';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shopping Cart",
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Color.fromARGB(255, 61, 62, 63),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 208, 0),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: _showHomePage
          ? SMItemlist()
          : SingleChildScrollView(
              child: Column(
                children: [
                  DataTable(
                    columnSpacing: 42.0,
                    columns: const [
                      DataColumn(
                          label: Text('Item',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Quantity',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Action',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: itemDataList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final itemData = entry.value;
                      final quantityController = TextEditingController(
                          text: itemData.quantity.toString());

                      return DataRow(cells: [
                        DataCell(Text(itemData.name)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove,
                                    size: 16, color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    if (itemData.quantity > 1) {
                                      itemData.quantity--;
                                      quantityController.text =
                                          itemData.quantity.toString();
                                    }
                                  });
                                },
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      itemData.quantity = int.parse(value);
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add,
                                    size: 16, color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    itemData.quantity++;
                                    quantityController.text =
                                        itemData.quantity.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: const Color.fromARGB(255, 184, 15, 3)),
                            onPressed: () {
                              setState(() {
                                itemDataList.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                  const SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      backgroundColor: Color.fromARGB(207, 49, 117, 163),
                      onPressed: () {
                        _toggleHomePage();
                      },
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      placeOrder();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(
                          255, 90, 121, 141), // Set the background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Apply rounded border
                      ),
                    ),
                    child: Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  // ... (Remaining code)
                ],
              ),
            ),
    );
  }
}

class ItemData {
  String name;
  int quantity;

  ItemData({required this.name, required this.quantity});
}
