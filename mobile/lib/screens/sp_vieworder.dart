import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/services/order_services.dart';

class SPViewOrder extends StatefulWidget {
  final String orderId;
  final String constructionSite;
  final String date;
  final String sitemanager;
  final int status;
  final List<Map<String, dynamic>> items;
  final double totalPrice;

  SPViewOrder({
    Key? key,
    required this.orderId,
    required this.constructionSite,
    required this.date,
    required this.items,
    required this.sitemanager,
    required this.status,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<SPViewOrder> createState() => _SPViewOrderState();
}

class _SPViewOrderState extends State<SPViewOrder> {
  Map<String, double> itemPrices = {};
  Map<String, TextEditingController?> itemPriceControllers = {};
  Map<String, bool> editMode = {};
  double totalPrice = 0.0;

  final OrderServices _orderServices = OrderServices();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current item prices
    for (var itemMap in widget.items) {
      final String itemName = itemMap['name'];
      final double itemPrice = itemMap['price'].toDouble();

      itemPrices[itemName] = itemPrice;

      itemPriceControllers[itemName] = TextEditingController(
        text: itemPrice.toStringAsFixed(2),
      );

      editMode[itemName] = false;
    }

    // Calculate initial total price
    calculateTotalPrice();
  }

  // Calculate the total price based on item prices
  // Calculate the total price based on item prices and quantities
  void calculateTotalPrice() {
    totalPrice = 0.0;
    for (var itemMap in widget.items) {
      final String itemName = itemMap['name'];
      final int itemQuantity = itemMap['quantity'];
      final double itemPrice = itemPrices[itemName] ?? 0.0;

      totalPrice += itemQuantity * itemPrice;
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    for (var controller in itemPriceControllers.values) {
      controller!.dispose();
    }
    super.dispose();
  }

  Widget buildDataContainer(String label, String value, {bool isBold = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20),
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
            '$label:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.black : Colors.grey,
            ),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  final DateFormat dateFormat = DateFormat("MMM d, y");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Order'),
        backgroundColor: const Color.fromARGB(255, 255, 208, 0),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDataContainer('Order ID', widget.orderId, isBold: true),
                  buildDataContainer(
                      'Construction Site', widget.constructionSite,
                      isBold: true),
                  buildDataContainer('Site Manager', widget.sitemanager,
                      isBold: true),
                  buildDataContainer(
                      'Date', dateFormat.format(DateTime.parse(widget.date)),
                      isBold: true),
                  buildDataContainer('Items', '', isBold: true),
                  for (var itemName in itemPrices.keys)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '${widget.items.firstWhere((item) => item['name'] == itemName)['quantity']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (!editMode[itemName]!)
                              Text(
                                'Rs.${itemPrices[itemName]?.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              )
                            else
                              Container(
                                width: 60,
                                child: TextField(
                                  controller: itemPriceControllers[itemName],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Rs.${itemPrices[itemName]?.toStringAsFixed(2)}',
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      double? editedPrice = double.tryParse(
                                          itemPriceControllers[itemName]!.text);
                                      if (editedPrice != null) {
                                        itemPrices[itemName] = editedPrice;
                                        calculateTotalPrice();
                                      }
                                    });
                                  },
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                editMode[itemName]! ? Icons.check : Icons.edit,
                                color: editMode[itemName]!
                                    ? Colors.green
                                    : const Color.fromARGB(255, 36, 36, 36),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (!editMode[itemName]!) {
                                    editMode[itemName] = true;
                                  } else {
                                    editMode[itemName] = false;
                                    double? editedPrice = double.tryParse(
                                        itemPriceControllers[itemName]!.text);
                                    if (editedPrice != null) {
                                      itemPrices[itemName] = editedPrice;
                                      calculateTotalPrice();
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  buildDataContainer(
                    'Total Price',
                    'Rs.${totalPrice.toStringAsFixed(2)}',
                    isBold: true,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    acceptOrder();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: Text('Accept', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    rejectOrder();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text('Reject', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendNewQuotation();
                    // Implement the Send New Questions button action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 255, 196, 0)),
                  ),
                  child: Text('Send New Quotation',
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 45.0),
        ],
      ),
    );
  }

// Function to send a new quotation
  void sendNewQuotation() {
    for (var itemName in itemPrices.keys) {
      if (editMode[itemName] == false) {
        double? editedPrice =
            double.tryParse(itemPriceControllers[itemName]!.text);
        if (editedPrice != null) {
          itemPrices[itemName] = editedPrice;
        }
      }
    }
    _orderServices.sendNewQuotation(widget.orderId, itemPrices);
    showCustomDialog(
        title: 'Quotation Sent',
        content: 'Your quotation has been sent successfully');
  }

// Function to reject an order
  void rejectOrder() {
    _orderServices.rejectOrder(widget.orderId);
    showCustomDialog(
        title: 'Order Rejected', content: 'The order has been rejected.');
  }

// Function to accept an order
  void acceptOrder() {
    _orderServices.acceptOrder(widget.orderId);
    showCustomDialog(
        title: 'Order Accepted', content: 'The order has been accepted.');
  }

  // Create a function to display a common dialog
  Future<void> showCustomDialog({
    required String title,
    required String content,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
