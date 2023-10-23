import 'package:flutter/material.dart';
import 'package:mobile/screens/sp_vieworder.dart';
import 'package:intl/intl.dart';

class SPOrderCard extends StatelessWidget {
  final String orderId;
  final String constructionSite;
  final String date;
  final String sitemanager;
  final int status;
  final List<Map<String, dynamic>> items; // Updated to accept a list of maps
  final double totalPrice;

  SPOrderCard({
    required this.orderId,
    required this.constructionSite,
    required this.date,
    required this.items,
    required this.sitemanager,
    required this.status,
    required this.totalPrice,
  });

  final DateFormat dateFormat = DateFormat("MMM d, y");

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
                  'Construction Site: $constructionSite',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Date: ${dateFormat.format(DateTime.parse(date))}',
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16.0,),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SPViewOrder(
                        orderId: orderId,
                        constructionSite: constructionSite,
                        date: date,
                        sitemanager: sitemanager,
                        status: status,
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


