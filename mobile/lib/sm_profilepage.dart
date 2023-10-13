import 'package:flutter/material.dart';

class SMProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData; // Add this line

  SMProfilePage({required this.userData, Key? key}) : super(key: key);

  @override
  _SMProfilePageState createState() => _SMProfilePageState();
}

class _SMProfilePageState extends State<SMProfilePage> {
  // Define variables to hold user details
  String managerName = ''; // Example initial values
  String email = '';
  String password = '';
  String contact = '';
  String companyName = '';
  String siteName = '';
  String siteNumber = '';

  // Define a TextEditingController for each input field
  TextEditingController managerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController siteNameController = TextEditingController();
  TextEditingController siteNumberController = TextEditingController();

  // Keep track of edit mode for each field
  bool managerNameEditMode = false;
  bool emailEditMode = false;
  bool passwordEditMode = false;
  bool contactEditMode = false;
  bool companyNameEditMode = false;
  bool siteNameEditMode = false;
  bool siteNumberEditMode = false;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingControllers and other variables with user data
    //managerName = widget.userData['managerName'] ?? '';
    email = widget.userData['email'] ?? '';
    password = widget.userData['password'] ?? '';
   // contact = widget.userData['contact'] ?? '';
   // companyName = widget.userData['companyName'] ?? '';
   // siteName = widget.userData['siteName'] ?? '';
   // siteNumber = widget.userData['siteNumber'] ?? '';

    // Initialize the TextEditingControllers with existing user details
    managerNameController.text = managerName;
    emailController.text = email;
    passwordController.text = password;
    contactController.text = contact;
    companyNameController.text = companyName;
    siteNameController.text = siteName;
    siteNumberController.text = siteNumber;
  }

  @override
  Widget build(BuildContext context) {
    print("UserData: ${widget.userData}");
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
                      managerNameController.text.isNotEmpty
                          ? managerNameController.text[0]
                          : '',
                      style: TextStyle(
                        fontSize: 38.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  managerNameController.text,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20.0), // Add spacing here
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildEditableField(managerNameController, 'Manager Name',
                        managerNameEditMode, () {
                      setState(() {
                        managerNameEditMode = !managerNameEditMode;
                      });
                    }, false),
                    buildEditableField(emailController, 'Email', emailEditMode,
                        () {
                      setState(() {
                        emailEditMode = !emailEditMode;
                      });
                    }, false),
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
                        contactController, 'Contact', contactEditMode, () {
                      setState(() {
                        contactEditMode = !contactEditMode;
                      });
                    }, false),
                    buildEditableField(companyNameController, 'Company Name',
                        companyNameEditMode, () {
                      setState(() {
                        companyNameEditMode = !companyNameEditMode;
                      });
                    }, false),
                    buildEditableField(
                        siteNameController, 'Site Address', siteNameEditMode,
                        () {
                      setState(() {
                        siteNameEditMode = !siteNameEditMode;
                      });
                    }, false),
                    buildEditableField(
                        siteNumberController, 'Site Number', siteNumberEditMode,
                        () {
                      setState(() {
                        siteNumberEditMode = !siteNumberEditMode;
                      });
                    }, false),
                    SizedBox(height: 12.0),
                  ],
                ),
              ),
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
                    onPressed: (){},
                    backgroundColor: Color.fromARGB(255, 90, 121, 141),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text(
                      'Update',
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
                icon: Icon(
                  isEditMode ? Icons.done : Icons.edit,
                  color: Color.fromARGB(255, 48, 70, 88),
                ),
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
              obscureText:
                  isPassword, // Add this line to obscure the text if it's a password field
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

