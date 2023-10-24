import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/services/auth_services.dart';

class SPAddItems extends StatefulWidget {
  final Map<String, dynamic> userData;

  SPAddItems({required this.userData, Key? key}) : super(key: key);

  @override
  State<SPAddItems> createState() => _SPAddItemsState();
}

class _SPAddItemsState extends State<SPAddItems> {
  final AuthService _authService = AuthService();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  Future<void> updateItems(List<Map<String, dynamic>> updatedItems) async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final userId = user.uid;
      final firestore = FirebaseFirestore.instance;

      final userDocsQuery =
          firestore.collection('suppliers').where('userId', isEqualTo: userId);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add to Shop",
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
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Text(
              "Add Items",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 35.0),
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

                    // Retrieve the existing items list
                    final existingItems = List<Map<String, dynamic>>.from(
                        widget.userData['items'] ?? []);

                    // Add the new item to the existing list
                    existingItems.add(newItem);

                    // Update the profile with the updated items
                    await updateItems(existingItems);

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
                  backgroundColor: Color.fromARGB(255, 90, 121, 141),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Apply rounded border
                  ),
                  textStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
