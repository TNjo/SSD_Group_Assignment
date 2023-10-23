import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/components/sm_itemlist.dart';
import 'package:mobile/services/auth_services.dart';
import 'package:mobile/services/order_services.dart';  // Import the OrderServices class
import 'package:mobile/services/siteman_services.dart';

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
  bool _showHomePage = false;
  final SiteManagerServices siteManagerServices = SiteManagerServices();
  final OrderServices orderServices = OrderServices(); // Create an instance of OrderServices
  final AuthService _authService = AuthService();

  void _toggleHomePage() {
    setState(() {
      _showHomePage = !_showHomePage;
    });
  }

  List<ItemData> itemDataList = [];

  void placeOrder() async {
    // Get the current user using the AuthService
    final user = _authService.getCurrentUser();
    if (user != null) {
      orderServices.placeOrder(siteName, managerName, user.uid, itemDataList);  // Use the instance of OrderServices
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
    }
  }


  @override
  void initState() {
    super.initState();

    // Initialize itemDataList based on selectedItems
    for (String itemName in widget.selectedItems) {
      itemDataList.add(ItemData(name: itemName, quantity: 1));
    }
    final user = _authService.getCurrentUser();
    
    if (user != null) {
      siteManagerServices.initializeSiteManagerData(widget.selectedItems, (name, company, site, number) {
      setState(() {
        managerName = name;
        companyName = company;
        siteName = site;
        siteNumber = number;
      });
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
                    rows: itemDataList.map((itemData) {
                      return DataRow(cells: [
                        DataCell(Text(itemData.name)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove,
                                    size: 16, color: Colors.blue),
                                onPressed: () {
                                  // Handle decreasing quantity
                                  setState(() {
                                    if (itemData.quantity > 1) {
                                      itemData.quantity--;
                                    }
                                  });
                                },
                              ),
                              Text(itemData.quantity
                                  .toString()), // Display the current quantity
                              IconButton(
                                icon: Icon(Icons.add,
                                    size: 16, color: Colors.blue),
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
                            icon: Icon(Icons.delete,
                                color: const Color.fromARGB(255, 184, 15, 3)),
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
                ],
              ),
            ),
    );
  }
}
