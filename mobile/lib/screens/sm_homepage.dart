import 'package:flutter/material.dart';
import 'package:mobile/screens/sm_cartpage.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class SMHomePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  SMHomePage({required this.userData, Key? key}) : super(key: key);

  @override
  State<SMHomePage> createState() => _SMHomePageState();
}

class _SMHomePageState extends State<SMHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> items = [
    'Cements',
    'Sands',
    'Blocks',
    'Rocks',
    'Wires',
    'Pipes',
  ];
  List<String> selectedItemsList = [];
  List<bool> selectedItems = List.generate(6, (index) => false);

  List<String> filteredItems = []; // Initialize the filtered items list

  @override
  void initState() {
    super.initState();
    // Initialize the filtered items list with all items
    filteredItems = items;
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
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredItems.length, // Use the filtered items
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
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 14.0),
                  SizedBox(
                    width: 150.0,
                    height: 50.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        List<String> selectedNames = [];
                        for (int i = 0; i < selectedItems.length; i++) {
                          if (selectedItems[i]) {
                            selectedNames.add(filteredItems[i]);
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SMCartPage(
                                selectedItems: selectedNames,
                                userData: widget.userData),
                          ),
                        );
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
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
