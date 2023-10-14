import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SPAddItems extends StatefulWidget {
  final Map<String, dynamic> userData;

  SPAddItems({required this.userData, Key? key}) : super(key: key);

  @override
  State<SPAddItems> createState() => _SPAddItemsState();
}

class _SPAddItemsState extends State<SPAddItems> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  Future<void> updateProfile(List<Map<String, dynamic>> updatedItems) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final firestore = FirebaseFirestore.instance;

      final userDocsQuery =
          firestore.collection('suppliers').where('userId', isEqualTo: userId);

      final userDocsSnapshot = await userDocsQuery.get();

      if (userDocsSnapshot.docs.isNotEmpty) {
        final userDocRef = userDocsSnapshot.docs[0].reference;

        await userDocRef.update({
          'items': updatedItems,
        });
      } else {
        print('Error: Document for user does not exist.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Items",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                color: Colors.grey,
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "Add Items",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            buildEditableField(itemNameController, 'Item Name'),
            buildEditableField(descriptionController, 'Description'),
            buildEditableField(priceController, 'Price',
                keyboardType: TextInputType.numberWithOptions(decimal: true)),
            buildEditableField(quantityController, 'Quantity',
                keyboardType: TextInputType.number),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  final itemName = itemNameController.text;
                  final description = descriptionController.text;
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  final quantity = int.tryParse(quantityController.text) ?? 0;

                  if (itemName.isNotEmpty) {
                    final newItem = {
                      'itemName': itemName,
                      'description': description,
                      'price': price,
                      'quantity': quantity,
                    };

                    // Create a copy of the existing items list and add the new item
                    final updatedItems = List<Map<String, dynamic>>.from(
                        widget.userData['items'] ?? []);
                    updatedItems.add(newItem);

                    // Update the profile with the updated items
                    await updateProfile(updatedItems);

                    print('Item Name: $itemName');
                    print('Description: $description');
                    print('Price: $price');
                    print('Quantity: $quantity');

                    itemNameController.clear();
                    descriptionController.clear();
                    priceController.clear();
                    quantityController.clear();
                  } else {
                    // Handle empty item name.
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Item Name is required"),
                        content: Text("Please enter a name for your item."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  onPrimary: Colors.black,
                  textStyle: TextStyle(
                    fontSize: 20.0,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                ),
                child: Text('Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(TextEditingController controller, String labelText,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: double.infinity,
            height: 45.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
