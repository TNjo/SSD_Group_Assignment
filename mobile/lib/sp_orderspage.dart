import 'package:mobile/components/sp_ordercard.dart';
import 'package:flutter/material.dart';

class SPOrdersPage extends StatefulWidget {
  const SPOrdersPage({super.key, required Map<String, dynamic> userData});

  @override
  State<SPOrdersPage> createState() => _SPOrdersPageState();
}

class _SPOrdersPageState extends State<SPOrdersPage> {
  @override
  Widget build(BuildContext context) {
    // List of order data (you can replace this with your actual data)
    final List<Map<String, String>> orderDataList = [
      {
        'companyName': 'Company A',
        'siteName': 'Site 1',
        'siteManager': 'John Doe',
        'contact': '123-456-7890',
        'requestDate': '2023-06-15',
        'items': 'Cement, Sand, Bricks',
        'totalPrice': '500.00',
      },
      {
        'companyName': 'Company B',
        'siteName': 'Site 2',
        'siteManager': 'Jane Smith',
        'contact': '987-654-3210',
        'requestDate': '2023-06-20',
        'items': 'Concrete, Steel, Nails',
        'totalPrice': '750.00',
      },
      {
        'companyName': 'Company C',
        'siteName': 'Site 3',
        'siteManager': 'Bob Johnson',
        'contact': '555-123-4567',
        'requestDate': '2023-06-25',
        'items': 'Wood, Paint, Screws',
        'totalPrice': '300.00',
      },
      // Add more order data as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
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
      body: ListView.builder(
        itemCount: orderDataList.length,
        itemBuilder: (context, index) {
          final orderData = orderDataList[index];
          return SPOrderCard(
            orderId: '', // Provide a default or empty value for orderId
            company: orderData['companyName'] ?? '',
            siteAddress: orderData['siteName'] ?? '',
            siteManager: orderData['siteManager'] ?? '',
            contact: orderData['contact'] ?? '',
            requestDate: orderData['requestDate'] ?? '',
            items: (orderData['items'] ?? '')
                .split(', '), // Convert comma-separated string to List<String>
            totalPrice: double.tryParse(orderData['totalPrice'] ?? '') ??
                0.0, // Convert string to double
          );
        },
      ),
    );
  }
}