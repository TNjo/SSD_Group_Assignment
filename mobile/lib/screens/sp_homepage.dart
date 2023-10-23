import 'package:flutter/material.dart';
import 'package:mobile/services/supplier_services.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class SPHomePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SPHomePage({required this.userData, Key? key}) : super(key: key);

  @override
  State<SPHomePage> createState() => _SPHomePageState();
}

class _SPHomePageState extends State<SPHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, Object>> items = [];
  List<Map<String, Object>> filteredItems = [];
  final SupplierServices supplierServices = SupplierServices();

  @override
  void initState() {
    super.initState();
    _fetchSupplierItems(); // Fetch items from Firestore on initialization
  }

  Future<void> _fetchSupplierItems() async {
    final userId = widget.userData['uid'];
    final fetchedItems = await supplierServices.fetchSupplierItems(userId);
    
    if (fetchedItems != null) {
      setState(() {
        items = fetchedItems;
        filteredItems = items;
      });
    }
  }

  void _editItemDetailsDialog(
      BuildContext context, Map<String, Object> item, int itemIndex) {
    TextEditingController itemNameController =
        TextEditingController(text: item['itemName'] as String);
    TextEditingController descriptionController =
        TextEditingController(text: item['description'] as String);
    TextEditingController priceController =
        TextEditingController(text: item['price'].toString());
    TextEditingController quantityController =
        TextEditingController(text: item['quantity'].toString());

    final userId = widget.userData['uid']; // Get the user's UID

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item: ${item['itemName']}'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Add input fields for editing item details
                TextFormField(
                  controller: itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final updatedItem = {
                  'itemName': itemNameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'quantity': int.parse(quantityController.text),
                };
                supplierServices.updateItem(userId, updatedItem, itemIndex);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save Changes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void deleteItem(context, index) async {
    final userId = widget.userData['uid'];
    supplierServices.deleteItem(userId, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "RenoveteryX",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(199, 158, 158, 158),
                    Color.fromARGB(136, 96, 125, 139)
                  ],
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20.0),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.68,
                          color: Color(0xff000000),
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Image.asset(
                        "assets/welcome_img.png",
                        width: 180.0,
                        height: 120.0,
                        scale: 0.1,
                      ),
                    ],
                  ),
                  SearchBarAnimation(
                    enableButtonBorder: true,
                    buttonBorderColour: Color.fromARGB(255, 48, 116, 161),
                    textEditingController: _searchController,
                    isOriginalAnimation: false,
                    trailingWidget: const Icon(Icons.search),
                    secondaryButtonWidget: const Icon(
                      Icons.cancel,
                      color: Color.fromARGB(255, 100, 147, 170),
                    ),
                    buttonWidget: const Icon(Icons.search),
                    searchBoxWidth: 340.0,
                    onFieldSubmitted: (String value) {
                      debugPrint('onFieldSubmitted value $value');
                    },
                    onChanged: (value) {
                      setState(() {
                        filteredItems = items
                            .where((item) =>
                                item['itemName'].toString().toLowerCase().contains(value))
                            .toList();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              color: Colors.grey,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 0.0, left: 20.0, right: 0.0),
                  child: Text(
                    'My Shop',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No items in shop',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 1, 66, 119),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final itemName = item['itemName'] as String;
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 12.0,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x5f000000),
                                offset: Offset(0.0, 4.0),
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$itemName',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  _editItemDetailsDialog(context, item, index);
                                },
                                child: Icon(Icons.edit,color: const Color.fromARGB(255, 0, 23, 43)),
                              ),
                              const SizedBox(width: 10.0),
                              GestureDetector(
                                onTap: () {
                                  deleteItem(context, index);
                                },
                                child: Icon(Icons.delete,color: const Color.fromARGB(255, 184, 15, 3)),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
