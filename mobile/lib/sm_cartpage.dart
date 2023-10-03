import 'package:flutter/material.dart';
import 'package:mobile/components/sm_itemlist.dart';

class SMCartPage extends StatefulWidget {
  const SMCartPage({super.key});

  @override
  State<SMCartPage> createState() => __SMCartState();
}

class __SMCartState extends State<SMCartPage> {

  bool _showHomePage = false;

  void _toggleHomePage() {
    setState(() {
      _showHomePage = !_showHomePage;
    });
  }

  List<ItemData> columns = [
    ItemData(name: 'Item 1', quantity: 1),
    ItemData(name: 'Item 2', quantity: 2),
    ItemData(name: 'Item 3', quantity: 3),
  ];

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
              icon: const Icon(Icons.arrow_back), // Add a back button icon
              onPressed: () {
                // Navigate back to the previous screen when the button is pressed
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: _showHomePage? SMItemlist():
      Center(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.all(16.0), // Adjust padding as needed
                child: DataTable(
                  columnSpacing: 42.0, // Increase the column spacing
                  columns: const [
                    DataColumn(label: Text('Item',style: TextStyle(fontWeight:FontWeight.bold,))),
                    DataColumn(label: Text('          Quantity',style: TextStyle(fontWeight:FontWeight.bold,))),
                    DataColumn(label: Text('Action',style: TextStyle(fontWeight:FontWeight.bold,))),
                  ],
                  rows: columns.map((item) {
                    TextEditingController quantityController = TextEditingController(text: item.quantity.toString());
      
                    return DataRow(cells: [
                      DataCell(Text(item.name)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove,size: 16,color: Colors.blue,),
                              onPressed: () {
                                setState(() {
                                  int currentQuantity = item.quantity;
                                  if (currentQuantity > 1) {
                                    currentQuantity--;
                                  }
                                  item.quantity = currentQuantity;
                                  quantityController.text = currentQuantity.toString();
                                });
                              },
                            ),
                            SizedBox(
                              width: 30.0, // Adjust spacing as needed
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: quantityController,
                                onChanged: (value) {
                                  int newQuantity = int.tryParse(value) ?? 0;
                                  setState(() {
                                    item.quantity = newQuantity;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add,size: 16,color: Colors.blue,),
                              onPressed: () {
                                setState(() {
                                  int currentQuantity = item.quantity;
                                  currentQuantity++;
                                  item.quantity = currentQuantity;
                                  quantityController.text = currentQuantity.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete,color: const Color.fromARGB(255, 184, 15, 3),),
                          onPressed: () {
                            setState(() {
                              columns.remove(item);
                            });
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 90, 121, 141),
                onPressed: () {
                 _toggleHomePage();
                },
                child: const Text('+',
                style: TextStyle(fontSize: 24),), // Add the text "plus (+)" to the button.
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
