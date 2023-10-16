import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PendingOrdersCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  PendingOrdersCard({Key? key, required this.userData}) : super(key: key);

  String getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Pending';
      case 2:
        return 'Sent to Supplier';
      case 3:
        return 'Sent to Manager';
      case 4:
        return 'Supplier Accepted';
      case 5:
        return 'Supplier Rejected';
      case 6:
        return 'Manager Rejected';  
      default:
        return 'Unknown';
    }
  }

  Color getColorForStatus(int status) {
    switch (status) {
      case 1:
        return Color.fromARGB(255, 255, 187, 0); // Custom color for Pending
      case 2:
        return Color.fromARGB(
            255, 0, 122, 255); // Custom color for Sent to Supplier
      case 3:
        return Color.fromARGB(
            255, 128, 0, 128); // Custom color for Sent to Manager
      case 4:
        return Color.fromARGB(
            255, 0, 163, 54); // Custom color for Supplier Accepted
      case 5:
        return Colors.red; // Default color for Supplier Rejected
      case 6:
        return Colors.red;  
      default:
        return Color.fromARGB(255, 0, 0, 0); // Default color for other statuses
    }
  }

// Define the date format
final DateFormat dateFormat = DateFormat("MMM d, y");

// Function to show order details in a dialog
  Future<void> _showOrderDetailsDialog(
      BuildContext context, Map<String, dynamic> order) async {
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Order Id: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: '${order['orderid']}'), // Value without bold
                    ],
                  ),
                ),
                Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: order['items'].map<Widget>((item) {
                    final itemName = item['name'] as String;
                    final itemQuantity = item['quantity'] as int;
                    return Text(
                      '$itemName: $itemQuantity',
                      style: TextStyle(
                        color: Color.fromARGB(255, 87, 87, 87),
                      ),
                    );
                  }).toList(),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Placed Date: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              '${dateFormat.format(order['date'].toDate())}'), // Value without bold
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Status: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: getStatusText(
                            order['status']), // Value without bold
                        style: TextStyle(
                          color: getColorForStatus(order['status']),
                        ),
                      )
                    ],
                  ),
                ),

                // Add more order details as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!.docs.where((orderDoc) {
            final orderData = orderDoc.data() as Map<String, dynamic>;
            // Filter orders with matching sitemanagerId and status 1, 3, or 5
            return orderData['sitemanagerId'] == userData['uid'] &&
                [1, 2, 3, 5, 6].contains(orderData['status']);
          }).toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(108, 217, 217, 217),
                        Color.fromARGB(22, 217, 217, 217),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Order Id: ${order['orderid']}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 8.0),
                        //   child: Text(
                        //     'Items: ${order['items'].join(', ')}',
                        //     style: TextStyle(
                        //       fontSize: 16.0,
                        //     ),
                        //     textAlign: TextAlign.left,
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Placed Date: ${dateFormat.format(order['date'].toDate())}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Status: '),
                                TextSpan(
                                  text: getStatusText(order['status']),
                                  style: TextStyle(
                                    color: getColorForStatus(order['status']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ButtonBar(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _showOrderDetailsDialog(context, order);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 93, 142, 189),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Text('View'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            height: 50,
            width: 50,
          );
        }
      },
    );
  }
}
