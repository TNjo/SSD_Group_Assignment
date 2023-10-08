import 'package:flutter/material.dart';

class SPProfilePage extends StatefulWidget {
  const SPProfilePage({super.key});

  @override
  State<SPProfilePage> createState() => _SPProfilePageState();
}

class _SPProfilePageState extends State<SPProfilePage> {
  // Define variables to hold user details
  String supplierName = 'John Doe'; // Example initial values
  String email = 'johndoe@example.com';
  String password = 'Site A';
  String contact = '123-456-7890';
  String address = 'ACME Corporation';

  // Define a TextEditingController for each input field
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();


  // Keep track of edit mode for each field
  bool supplierNameEditMode = false;
  bool emailEditMode = false;
  bool passwordEditMode = false;
  bool contactEditMode = false; 
  bool addressEditMode = false;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingControllers with existing user details
    supplierNameController.text = supplierName;
    emailController.text = email;
    passwordController.text = password;
    addressController.text = address;
    contactController.text = contact;    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30.0),
          Align(
            alignment:
                Alignment.topCenter, // Align the container to the top center
            child: Column(
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 87, 136, 177),
                  ),
                  child: Center(
                    child: Text(
                      supplierNameController.text.isNotEmpty ? supplierNameController.text[0] : '',
                      style: TextStyle(fontSize: 38.0,color: Colors.white,fontWeight: FontWeight.bold,),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  supplierNameController.text,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20.0), // Add spacing here
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildEditableField(
                      supplierNameController,
                      'Supplier Name',
                      supplierNameEditMode,
                      () {
                        setState(() {
                          supplierNameEditMode = !supplierNameEditMode;
                        });
                      },
                      false
                    ),
                    buildEditableField(
                      emailController,
                      'Email',
                      emailEditMode,
                      () {
                        setState(() {
                          emailEditMode = !emailEditMode;
                        });
                      },
                      false
                    ),
                    buildEditableField(
                      passwordController,
                      'Password',
                      passwordEditMode,
                      () {
                        setState(() {
                          passwordEditMode = !passwordEditMode;
                        });
                      },
                      true,
                    ),
                    buildEditableField(
                      addressController,
                      'Address',
                      addressEditMode,
                      () {
                        setState(() {
                          addressEditMode = !addressEditMode;
                        });
                      },
                      false,
                    ),                    
                    buildEditableField(
                      contactController,
                      'Contact',
                      contactEditMode,
                      () {
                        setState(() {
                          contactEditMode = !contactEditMode;
                        });
                      },
                      false,
                    ),
                    SizedBox(height: 37.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget buildEditableField(
  TextEditingController controller,
  String labelText,
  bool isEditMode,
  VoidCallback onEditPressed,
  bool isPassword, // Add a boolean flag to indicate if it's a password field
) {
  return Padding(
    padding: EdgeInsets.only(top: 3.0, bottom: 0.0, left: 20.0, right: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelText,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(isEditMode ? Icons.done : Icons.edit, color: Color.fromARGB(255, 48, 70, 88),),
              onPressed: () {
                onEditPressed();
                if (isEditMode) {
                  // Save the edited value to your data model or perform any other action.
                  // You can use the controller to get the updated value.
                  final editedValue = controller.text;
                  print('Edited value: $editedValue');
                }
              },
            ),
          ],
        ),
        Container(
          width: 360.0, // Set the desired width
          height: 45.0, // Set the desired height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword, // Add this line to obscure the text if it's a password field
            readOnly: !isEditMode,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.0),
      ],
    ),
  );
}
}