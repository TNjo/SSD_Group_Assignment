import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
class SPHomePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SPHomePage({required this.userData, Key? key}) : super(key: key);

  @override
  State<SPHomePage> createState() => _SPHomePageState();
}

class _SPHomePageState extends State<SPHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> items = [];
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize the filtered items list with all items
    retrieveItems(); // Load items from Firestore
  }

  void retrieveItems() async {
    // Assuming you have the user's UID in 'userData'
    final userUid = widget.userData['uid'];

    // Retrieve the relevant supplier document based on the user's UID
    final supplierCollection = FirebaseFirestore.instance.collection('suppliers');
    final userSupplierDocument = supplierCollection.doc(userUid);

    final docSnapshot = await userSupplierDocument.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        // Get the 'items' field from the supplier document
        if (data.containsKey('items') && data['items'] is List) {
          setState(() {
            items = List<String>.from(data['items']);
            filteredItems = items;
          });
        }
      }
    }
  }

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
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
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
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(199, 158, 158, 158),
                    Color.fromARGB(136, 96, 125, 139)
                  ],
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20.0),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.68,
                          color: Color(0xff000000),
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Image.asset(
                        "assets/welcome_img.png",
                        width: 180.0,
                        height: 120.0,
                        scale: 0.1,
                      ),
                    ],
                  ),
                  SearchBarAnimation(
                    enableButtonBorder: true,
                    buttonBorderColour: Color.fromARGB(255, 48, 116, 161),
                    textEditingController: _searchController,
                    isOriginalAnimation: false,
                    trailingWidget: const Icon(Icons.search),
                    secondaryButtonWidget: const Icon(
                      Icons.cancel,
                      color: Color.fromARGB(255, 100, 147, 170),
                    ),
                    buttonWidget: const Icon(Icons.search),
                    searchBoxWidth: 340.0,
                    onFieldSubmitted: (String value) {
                      debugPrint('onFieldSubmitted value $value');
                    },
                    onChanged: (value) {
                      // Filter the items based on the search query
                      setState(() {
                        filteredItems = items
                            .where((item) =>
                                item.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
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
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    padding: const EdgeInsets.all(16.0),
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x5f000000),
                          offset: Offset(0.0, 4.0),
                          blurRadius: 12.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(filteredItems[index],
                            style: const TextStyle(fontSize: 16.0)),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Implement your edit action
                          },
                          child: Icon(Icons.edit),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            // Implement your delete action
                          },
                          child: Icon(Icons.delete),
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
    );
  }
}