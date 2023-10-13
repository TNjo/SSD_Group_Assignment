import 'package:flutter/material.dart';
import 'package:mobile/sp_vieworder.dart';

class SPOrderCard extends StatelessWidget {
  final String orderId;
  final String company;
  final String siteManager;
  final String siteAddress;
  final String contact;
  final String requestDate;
  final List<String> items;
  final double totalPrice;

  SPOrderCard({
    required this.orderId,
    required this.company,
    required this.siteManager,
    required this.siteAddress,
    required this.contact,
    required this.requestDate,
    required this.items,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company Name: $company',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Site Address: $siteAddress',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8.0,
            right: 8.0,
            child: SizedBox(
              width: 80.0,
              height: 30.0,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the SPViewOrder page and pass the data
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SPViewOrder(
                        orderId: orderId,
                        company: company,
                        siteManager: siteManager,
                        siteAddress: siteAddress,
                        contact: contact,
                        requestDate: requestDate,
                        items: items,
                        totalPrice: totalPrice,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'View',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



