import 'package:flutter/material.dart';

class SPViewOrder extends StatefulWidget {
  final String orderId;
  final String company;
  final String siteManager;
  final String siteAddress;
  final String contact;
  final String requestDate;
  final List<String> items;
  final double totalPrice;

  // Provide default values for the properties
  SPViewOrder({
    Key? key,
    this.orderId = '#00003',
    this.company = 'Maga Constructons',
    this.siteManager = 'Pamitha Lokuge',
    this.siteAddress = 'No 1 , Temple Road , Galle',
    this.contact = '0112345678',
    this.requestDate = '2023.05.25',
    this.items = const ['Cement', 'Sand', 'Wires'],
    this.totalPrice = 0.0,
  }) : super(key: key);

  @override
  State<SPViewOrder> createState() => _SPViewOrderState();
}

class _SPViewOrderState extends State<SPViewOrder> {
  // Define a map to store item prices
  Map<String, double> itemPrices = {
    'Cement': 10.0,
    'Sand': 5.0,
    'Wires': 8.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Order'),
        backgroundColor: Colors.yellow, // Change the app bar background color
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container for "Order ID" and its data
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20), // Increase vertical spacing
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Order ID:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black text color for label
                          ),
                        ),
                        SizedBox(width: 10), // Add horizontal spacing
                        Text(
                          widget.orderId,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey, // Light gray text color for data
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container for "Company" and its data
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20), // Increase vertical spacing
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Company:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black text color for label
                          ),
                        ),
                        SizedBox(width: 10), // Add horizontal spacing
                        Text(
                          widget.company,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey, // Light gray text color for data
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container for "Site Manager" and its data
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20), // Increase vertical spacing
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Site Manager:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black text color for label
                          ),
                        ),
                        SizedBox(width: 10), // Add horizontal spacing
                        Text(
                          widget.siteManager,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Light gray text color for data
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container for "Site Address" and its data
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20), // Increase vertical spacing
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Site Address:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black text color for label
                          ),
                        ),
                        SizedBox(width: 10), // Add horizontal spacing
                        Text(
                          widget.siteAddress,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Light gray text color for data
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container for "Contact" and its data
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20), // Increase vertical spacing
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Contact:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black text color for label
                          ),
                        ),
                        SizedBox(width: 10), // Add horizontal spacing
                        Text(
                          widget.contact,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Light gray text color for data
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container for "Request Date" and its data
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20), // Increase vertical spacing
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Request Date:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black text color for label
                          ),
                        ),
                        SizedBox(width: 10), // Add horizontal spacing
                        Text(
                          widget.requestDate,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Light gray text color for data
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container for "Items" label
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20), // Increase vertical spacing
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Items:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Display item names, prices, and edit buttons
                  for (var item in widget.items)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Light gray text color for item name
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${itemPrices[item]?.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey, // Light gray text color for item price
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Implement the edit price action
                                // You can show a dialog or navigate to a new screen for editing
                                // For simplicity, I'll show a snackbar here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Edit $item Price'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                  // Container for "Total Price" and its data
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 70), // Increase vertical spacing
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black text color for label
                          ),
                        ),
                        SizedBox(width: 10), // Add horizontal spacing
                        Text(
                          '\$${calculateTotalPrice().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // Green text color for total price
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20), // Add vertical spacing
                ],
              ),
            ),
          ),

          // Buttons
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement the Confirm button action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.green), // Change the button background color
                  ),
                  child: Text('Confirm', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement the Reject button action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.red), // Change the button background color
                  ),
                  child: Text('Reject', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement the Send New Questions button action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.yellow), // Change the button background color
                  ),
                  child: Text('Send New Questions', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to calculate the total price
  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in widget.items) {
      if (itemPrices.containsKey(item)) {
        total += itemPrices[item]!;
      }
    }
    return total;
  }
}




