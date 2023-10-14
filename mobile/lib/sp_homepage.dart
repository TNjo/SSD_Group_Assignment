import 'package:flutter/material.dart';

class SPHomePage extends StatefulWidget {
  const SPHomePage({super.key});

  @override
  State<SPHomePage> createState() => _SPHomePageState();
}

class _SPHomePageState extends State<SPHomePage> {
  // final TextEditingController _searchController = TextEditingController();
  List<String> items = [
    'Cement',
    'Sands',
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
        title: const Text(
          "RenoveteryX",
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 30.0, right:30.0),
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 68, 68, 68),
                      Color.fromARGB(255, 248, 204, 57),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  width: double.infinity, // Match the screen width
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80.0, // Decrease the circle size
                          height: 80.0, // Decrease the circle size
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 217,217,217,),
                          ),
                          child: Center(
                            child: Text(
                              'B',
                              style: TextStyle(
                                fontSize: 38.0,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          'BrickShop',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Contact No',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 20.0),
            Container(
              color: Colors.grey, // Gray background color
              child: Container(
                width: double.infinity, // Match the screen width
                padding: EdgeInsets.symmetric(
                    vertical: 16.0), // Adjust vertical padding as needed
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right:0.0),
                  child: Text(
                    'My Shop', // Your heading text
                    style: TextStyle(
                      fontSize: 24, // Adjust the font size as needed
                      fontWeight:
                          FontWeight.bold, // Make the text bold if needed
                    ),
                  ),
                  // You can add more widgets or text here if needed
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    padding: const EdgeInsets.all(16.0),
                    height: 50.0, // Set the desired height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          10.0), // Increase the corner radius
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x5f000000), // Increase shadow opacity
                          offset: Offset(0.0, 4.0), // Increase shadow offset
                          blurRadius: 12.0, // Increase shadow blur radius
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(items[index],
                            style: const TextStyle(fontSize: 16.0)),
                            Spacer(),
                        Icon(Icons.edit),
                        const SizedBox(width: 10.0),
                        Icon(Icons.delete)
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 14.0),
                  SizedBox(
                    width: 150.0,
                    height: 50.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sm_navbar',
                            arguments: 2);
                      },
                      backgroundColor: Color.fromARGB(255, 90, 121, 141),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 43.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
