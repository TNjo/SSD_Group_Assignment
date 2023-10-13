import 'package:flutter/material.dart';
import 'package:mobile/components/sm_approvedcard.dart';
import 'package:mobile/components/sm_pendingcard.dart';


class SMOrdersPage extends StatefulWidget {
  final Map<String, dynamic> userData; // Add this line

  SMOrdersPage({required this.userData, Key? key}) : super(key: key);

  @override
  _SMOrdersPageState createState() => _SMOrdersPageState();
}

class _SMOrdersPageState extends State<SMOrdersPage> {
  bool showPendingOrders = true; // Initially, show pending orders

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          const SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showPendingOrders = true;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: showPendingOrders
                      ? MaterialStateProperty.all( Color.fromARGB(255, 255, 187, 0),)
                      : MaterialStateProperty.all(Colors.grey),
        //               side: MaterialStateProperty.all(
        //   BorderSide(
        //     color: Colors.black, // Border color
        //     width: 2.0, // Border width
        //   ),
        // ),
                ),
                child: Text('Pending Orders'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showPendingOrders = false;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: showPendingOrders
                      ? MaterialStateProperty.all(Colors.grey)
                      :  MaterialStateProperty.all( Color.fromARGB(255, 255, 187, 0),)
                ),
                child: Text('Approved Orders'),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: showPendingOrders
                ? PendingOrdersCard() 
                : ApprovedOrdersCard(),
          ),
        ],
      ),
    );
  }
}