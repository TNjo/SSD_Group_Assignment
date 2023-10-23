import 'package:mobile/components/sp_ordercard.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/order_services.dart';

class SPOrdersPage extends StatefulWidget {
  const SPOrdersPage({super.key, required Map<String, dynamic> userData});

  @override
  State<SPOrdersPage> createState() => _SPOrdersPageState();
}

class _SPOrdersPageState extends State<SPOrdersPage> {
  List<Map<dynamic, dynamic>> orderDataList = [];
  final OrderServices orderServices = OrderServices();

  @override
  void initState() {
    super.initState();
    // Fetch orders for the current user's email
    fetchOrdersForCurrentSP();
  }

  Future<void> fetchOrdersForCurrentSP() async {
    final orders = await orderServices.fetchOrdersForCurrentSP();

    if (orders != null) {
      setState(() {
        orderDataList = orders;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // List of order data (you can replace this with your actual data)
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
            orderId: orderData['orderId'] ?? '',
            constructionSite: orderData['constructionSite'] ?? '',
            date: orderData['date'] ?? '',
            items: (orderData['items'] ?? List<Map<String, dynamic>>),
            sitemanager: orderData['sitemanager'] ?? '',
            status: orderData['status'] ??
                0, // Provide a default value if 'status' is missing
            totalPrice: (orderData['totalPrice'] ?? 0.0)
                .toDouble(), // Provide a default value if 'totalPrice' is missing
          );
        },
      ),
    );
  }
}
