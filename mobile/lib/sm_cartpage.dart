import 'package:flutter/material.dart';
import 'package:mobile/components/sm_itemlist.dart';

class SMCartPage extends StatefulWidget {
  final List<String> selectedItems;
  final Map<String, dynamic> userData; // Add this line

  SMCartPage({Key? key, required this.selectedItems, required this.userData}) : super(key: key);

  @override
  State<SMCartPage> createState() => _SMCartState();
}


class _SMCartState extends State<SMCartPage> {
  bool _showHomePage = false;

  void _toggleHomePage() {
    setState(() {
      _showHomePage = !_showHomePage;
    });
  }

  List<ItemData> itemDataList = [];

  @override
  void initState() {
    super.initState();

    // Initialize itemDataList based on selectedItems
    for (String itemName in widget.selectedItems) {
      itemDataList.add(ItemData(name: itemName, quantity: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
     print("UserData: ${widget.userData}");
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
                      DataColumn(label: Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: itemDataList.map((itemData) {
                      return DataRow(cells: [
                        DataCell(Text(itemData.name)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, size: 16, color: Colors.blue),
                                onPressed: () {
                                  // Handle decreasing quantity
                                  setState(() {
                                    if (itemData.quantity > 1) {
                                      itemData.quantity--;
                                    }
                                  });
                                },
                              ),
                              Text(itemData.quantity.toString()), // Display the current quantity
                              IconButton(
                                icon: Icon(Icons.add, size: 16, color: Colors.blue),
                                onPressed: () {
                                  // Handle increasing quantity
                                  setState(() {
                                    itemData.quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: const Color.fromARGB(255, 184, 15, 3)),
                            onPressed: () {
                              // Handle removing the item from the itemDataList
                              setState(() {
                                itemDataList.remove(itemData);
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
                      backgroundColor: Color.fromARGB(255, 90, 121, 141),
                      onPressed: () {
                        _toggleHomePage();
                      },
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
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

