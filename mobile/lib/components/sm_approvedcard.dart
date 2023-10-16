import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ApprovedOrdersCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  ApprovedOrdersCard({Key? key, required this.userData}) : super(key: key);

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
            default:
                return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat("MMM d, y");
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!.docs.where((orderDoc) {
            final orderData = orderDoc.data() as Map<String, dynamic>;
            // Filter orders with matching sitemanagerId and status 1, 2, or 3
            return orderData['sitemanagerId'] == userData['uid'] && [4].contains(orderData['status']);
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
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Items: ${order['items'].join(', ')}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
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
                                color: Colors.black, // Set label color to black
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Status: '),
                                TextSpan(
                                  text: getStatusText(order['status']),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 129, 65), // Set status value color based on status
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Supplier: ${order['supplier']}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Total Price: ${order['totalPrice']}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        ButtonBar(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // View pending order logic
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
                            ElevatedButton(
                              onPressed: () {
                                // Cancel pending order logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(148, 7,114,60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Text('Recieved'),
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