import 'package:flutter/material.dart';

class PendingOrdersCard extends StatefulWidget {
  const PendingOrdersCard({super.key});

  @override
  State<PendingOrdersCard> createState() => _PendingOrdersCardState();
}

class _PendingOrdersCardState extends State<PendingOrdersCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: /* Number of pending orders */ 5,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(16.0),
          elevation: 5, // Add shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Add corner radius
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
                ], // Define your gradient colors
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 8.0), // Add space between Text widgets
                    child: const Text(
                      'Items: Cement,Sand',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 8.0), // Add space between Text widgets
                    child: Text(
                      'Placed Date: Date $index',
                      style: const TextStyle(
                        fontSize: 16.0,
                        //fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                  ),
                  Container(
                  margin: EdgeInsets.only(bottom: 8.0), // Add space between Text widgets
                  child: Text(
                    'Status: Pending',
                    style: TextStyle(
                      fontSize: 16.0,
                      //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left, // Align text to the left
                  ),
                  ),
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // View pending order logic
                        },
                        style: ElevatedButton.styleFrom(
                          //backgroundColor: Color.fromARGB(255, 255, 174, 0), // Custom button color
                          backgroundColor: Color.fromARGB(255, 93, 142, 189),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Add corner radius
                          ),
                        ),
                        child: Text('View'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Cancel pending order logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(237, 204, 14, 0), // Custom button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Add corner radius
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
  }
}
