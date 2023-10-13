import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedOrdersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'App') // Filter by status
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!.docs;
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
                            'Placed Date: ${order['date'].toString()}', // You should format the date as needed
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Status: ${order['status']}',
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
                                backgroundColor: Color.fromARGB(255, 93, 142, 189),
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
                                backgroundColor: Color.fromARGB(237, 204, 14, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Text('Cancel'),
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
          return Container(height: 50,width: 50,);
        }
      },
    );
  }
}