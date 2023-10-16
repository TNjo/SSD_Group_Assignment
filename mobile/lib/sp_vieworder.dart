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
  Map<String, double> itemPrices = {
    'Cement': 10.0,
    'Sand': 5.0,
    'Wires': 8.0,
  };

  Map<String, TextEditingController?> itemPriceControllers = {};
  Map<String, bool> editMode = {};
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current item prices
    for (var item in widget.items) {
      itemPriceControllers[item] = TextEditingController(
        text: itemPrices[item]?.toStringAsFixed(2),
      );
      editMode[item] = false;
    }

    // Calculate initial total price
    calculateTotalPrice();
  }

  // Calculate the total price based on item prices
  void calculateTotalPrice() {
    totalPrice = 0.0;
    for (var item in widget.items) {
      double? itemPrice = itemPrices[item];
      if (itemPrice != null) {
        totalPrice += itemPrice;
      }
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
                  buildDataContainer('Order ID', widget.orderId),
                  buildDataContainer('Company', widget.company),
                  buildDataContainer('Site Manager', widget.siteManager,
                      isBold: true),
                  buildDataContainer('Site Address', widget.siteAddress,
                      isBold: true),
                  buildDataContainer('Contact', widget.contact, isBold: true),
                  buildDataContainer('Request Date', widget.requestDate,
                      isBold: true),
                  buildDataContainer('Items', '', isBold: true),
                  for (var item in widget.items)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            if (!editMode[item]!)
                              Text(
                                '\$${itemPrices[item]?.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              )
                            else
                              Container(
                                width: 60,
                                child: TextField(
                                  controller: itemPriceControllers[item],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText:
                                        '\$${itemPrices[item]?.toStringAsFixed(2)}',
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      double? editedPrice =
                                          double.tryParse(
                                              itemPriceControllers[item]!
                                                  .text);
                                      if (editedPrice != null) {
                                        itemPrices[item] = editedPrice;
                                        calculateTotalPrice();
                                      }
                                    });
                                  },
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                editMode[item]!
                                    ? Icons.check
                                    : Icons.edit,
                                color: editMode[item]!
                                    ? Colors.green
                                    : const Color.fromARGB(255, 36, 36, 36),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (!editMode[item]!) {
                                    editMode[item] = true;
                                  } else {
                                    editMode[item] = false;
                                    double? editedPrice =
                                        double.tryParse(
                                            itemPriceControllers[item]!
                                                .text);
                                    if (editedPrice != null) {
                                      itemPrices[item] = editedPrice;
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
                    '\$${totalPrice.toStringAsFixed(2)}',
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
                    // Implement the Confirm button action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: Text('Confirm', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement the Reject button action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text('Reject', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement the Send New Questions button action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 196, 0)),
                  ),
                  child: Text('Send New Questions',
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
}





