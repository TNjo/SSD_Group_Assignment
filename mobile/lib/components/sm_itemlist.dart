import 'package:flutter/material.dart';
import 'package:mobile/sm_cartpage.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class SMItemlist extends StatefulWidget {
  const SMItemlist({super.key});

  @override
  _SMItemlistState createState() =>
      _SMItemlistState();
}

class _SMItemlistState
    extends State<SMItemlist> {
  final TextEditingController _searchController = TextEditingController();
  List<String> items = [
    'Cement',
    'Sand',
    'Blocks',
    'Rocks',
    'Wires',
    'Pipes',
  ];
  List<String> selectedItemsList = [];

  List<bool> selectedItems = List.generate(6, (index) => false);

  void handleSearchSubmitted(String value) {
    debugPrint('onFieldSubmitted value $value');
    // Add your search logic here
  }

  void handleAddToCartPressed() {
    // Add to cart functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 0.0, left: 12.0, right: 12.0),
            child: SearchBarAnimation(
              enableButtonBorder: true,
              hintText: "Search Here",
              hintTextColour: const Color.fromARGB(255, 0, 0, 0),
              cursorColour: Colors.white,
              //buttonBorderColour: Color.fromARGB(255, 255, 208, 0),
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
              searchBoxColour: const Color.fromARGB(174, 158, 158, 158),
              onFieldSubmitted: handleSearchSubmitted,
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
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
                      Text(items[index], style: const TextStyle(fontSize: 16.0)),
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
                    onPressed: (){// Pass selected items to the cart page.
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => SMCartPage(selectedItems: selectedItemsList),
                  //   ),
                  // );
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
                const SizedBox(height: 45.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
