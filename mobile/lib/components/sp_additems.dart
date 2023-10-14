import 'package:flutter/material.dart';

class SPAddItems extends StatefulWidget {
  final Map<String, dynamic> userData;
  SPAddItems({required this.userData, Key? key}) : super(key: key);

  @override
  State<SPAddItems> createState() => _SPAddItemsState();
}

class _SPAddItemsState extends State<SPAddItems> {
  // Define variables to hold item details
  String itemName = '';
  String description = '';
  double price = 0.0;
  int quantity = 0;

  // Define TextEditingController for each input field
  TextEditingController itemNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  // Keep track of edit mode for each field
  bool itemNameEditMode = true;
  bool descriptionEditMode = true;
  bool priceEditMode = true;
  bool quantityEditMode = true;

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
            // Container with background color for "Add Items" text
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                color: Colors.grey, // Set your desired background color
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "Add Items",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // You can customize the text color
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            buildEditableField(
              itemNameController,
              'Item Name',
              itemNameEditMode,
              () {
                setState(() {
                  itemNameEditMode = !itemNameEditMode;
                });
              },
              false,
            ),
            buildEditableField(
              descriptionController,
              'Description',
              descriptionEditMode,
              () {
                setState(() {
                  descriptionEditMode = !descriptionEditMode;
                });
              },
              false,
            ),
            buildEditableField(
              priceController,
              'Price',
              priceEditMode,
              () {
                setState(() {
                  priceEditMode = !priceEditMode;
                });
              },
              false,
            ),
            buildEditableField(
              quantityController,
              'Quantity',
              quantityEditMode,
              () {
                setState(() {
                  quantityEditMode = !quantityEditMode;
                });
              },
              false,
            ),
            SizedBox(height: 20.0),
            // The "Add Item" button wrapped in a centered Container
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Handle the submission of item details here.
                  final itemName = itemNameController.text;
                  final description = descriptionController.text;
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  final quantity = int.tryParse(quantityController.text) ?? 0;

                  // Print or save the item details.
                  print('Item Name: $itemName');
                  print('Description: $description');
                  print('Price: $price');
                  print('Quantity: $quantity');

                  // You can perform further actions like saving the data to a database.
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow, // Background color
                  onPrimary: Colors.black, // Text color
                  textStyle: TextStyle(
                    fontSize: 20.0, // Font size
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0), // Button size
                ),
                child: Text('Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(
    TextEditingController controller,
    String labelText,
    bool isEditMode,
    VoidCallback onEditPressed,
    bool isPassword,
  ) {
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
              obscureText: isPassword,
              readOnly: !isEditMode,
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


