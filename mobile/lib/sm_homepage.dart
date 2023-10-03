import 'package:flutter/material.dart';

class SMHomePage extends StatefulWidget {
  const SMHomePage({Key? key}) : super(key: key);

  @override
  State<SMHomePage> createState() => _SMHomePageState();
}

class _SMHomePageState extends State<SMHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> items = [
    'Cement',
    'Sand',
    'Blocks',
    'Rocks',
    'Wires',
    'Pipes',
  ];

  List<bool> selectedItems = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RenoveteryX",
          style: TextStyle(
            fontFamily: 'OpenSans',
          ),
        ),
        backgroundColor:Color.fromARGB(255, 255, 208, 0),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back), // Add a back button icon
              onPressed: () {
                // Navigate back to the previous screen when the button is pressed
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xffd9d9d9),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'Items',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.68,
                  color: Color(0xff000000),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3f000000),
                    offset: Offset(5.0, 4.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search an item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3f000000),
                          offset: Offset(0.0, 2.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(items[index], style: TextStyle(fontSize: 16.0)),
                        Checkbox(
                          value: selectedItems[index],
                          onChanged: (value) {
                            setState(() {
                              selectedItems[index] = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Add to cart functionality here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow, // Set the background color to yellow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text('Add to Cart'),
        ),
      ),
    );
  }
}
