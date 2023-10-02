// import 'package:flutter/material.dart';

// class MyProfilePage extends StatefulWidget {
//   @override
//   _MyProfilePageState createState() => _MyProfilePageState();
// }

// class _MyProfilePageState extends State<MyProfilePage> {
//   // Define variables to hold user details
//   String managerName = 'John Doe'; // Example initial values
//   String email = 'johndoe@example.com';
//   String contact = '123-456-7890';
//   String companyName = 'ACME Corporation';
//   String siteName = 'Site A';
//   String siteNumber = '123';

//   // Define a TextEditingController for each input field
//   TextEditingController managerNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   TextEditingController companyNameController = TextEditingController();
//   TextEditingController siteNameController = TextEditingController();
//   TextEditingController siteNumberController = TextEditingController();

//   // Keep track of edit mode for each field
//   bool managerNameEditMode = false;
//   bool emailEditMode = false;
//   bool contactEditMode = false;
//   bool companyNameEditMode = false;
//   bool siteNameEditMode = false;
//   bool siteNumberEditMode = false;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the TextEditingControllers with existing user details
//     managerNameController.text = managerName;
//     emailController.text = email;
//     contactController.text = contact;
//     companyNameController.text = companyName;
//     siteNameController.text = siteName;
//     siteNumberController.text = siteNumber;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.yellow,
//         title: Text('My Profile'),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.only(top: 80.0), // Add spacing here
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildEditableField(
//                   managerNameController,
//                   'Manager Name',
//                   managerNameEditMode,
//                   () {
//                     setState(() {
//                       managerNameEditMode = !managerNameEditMode;
//                     });
//                   },
//                 ),
//                 buildEditableField(
//                   emailController,
//                   'Email',
//                   emailEditMode,
//                   () {
//                     setState(() {
//                       emailEditMode = !emailEditMode;
//                     });
//                   },
//                 ),
//                 buildEditableField(
//                   contactController,
//                   'Contact',
//                   contactEditMode,
//                   () {
//                     setState(() {
//                       contactEditMode = !contactEditMode;
//                     });
//                   },
//                 ),
//                 buildEditableField(
//                   companyNameController,
//                   'Company Name',
//                   companyNameEditMode,
//                   () {
//                     setState(() {
//                       companyNameEditMode = !companyNameEditMode;
//                     });
//                   },
//                 ),
//                 buildEditableField(
//                   siteNameController,
//                   'Site Name',
//                   siteNameEditMode,
//                   () {
//                     setState(() {
//                       siteNameEditMode = !siteNameEditMode;
//                     });
//                   },
//                 ),
//                 buildEditableField(
//                   siteNumberController,
//                   'Site Number',
//                   siteNumberEditMode,
//                   () {
//                     setState(() {
//                       siteNumberEditMode = !siteNumberEditMode;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 168, 168, 168),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(10.0),
//                 bottomRight: Radius.circular(10.0),
//               ),
//             ),
//             child: Text(
//               'My Profile',
//               style: TextStyle(
//                 fontSize: 28.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildEditableField(TextEditingController controller, String labelText, bool isEditMode, VoidCallback onEditPressed) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 labelText,
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(isEditMode ? Icons.done : Icons.edit),
//                 onPressed: () {
//                   onEditPressed();
//                   if (isEditMode) {
//                     // Save the edited value to your data model or perform any other action.
//                     // You can use the controller to get the updated value.
//                     final editedValue = controller.text;
//                     print('Edited value: $editedValue');
//                   }
//                 },
//               ),
//             ],
//           ),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: controller,
//               readOnly: !isEditMode,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 16.0),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // Define variables to hold user details
  String managerName = 'John Doe'; // Example initial values
  String email = 'johndoe@example.com';
  String contact = '123-456-7890';
  String companyName = 'ACME Corporation';
  String siteName = 'Site A';
  String siteNumber = '123';

  // Define a TextEditingController for each input field
  TextEditingController managerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController siteNameController = TextEditingController();
  TextEditingController siteNumberController = TextEditingController();

  // Keep track of edit mode for each field
  bool managerNameEditMode = false;
  bool emailEditMode = false;
  bool contactEditMode = false;
  bool companyNameEditMode = false;
  bool siteNameEditMode = false;
  bool siteNumberEditMode = false;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingControllers with existing user details
    managerNameController.text = managerName;
    emailController.text = email;
    contactController.text = contact;
    companyNameController.text = companyName;
    siteNameController.text = siteName;
    siteNumberController.text = siteNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('My Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 168, 168, 168),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Text(
              'My Profile',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20.0), // Add spacing here
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildEditableField(
                      managerNameController,
                      'Manager Name',
                      managerNameEditMode,
                      () {
                        setState(() {
                          managerNameEditMode = !managerNameEditMode;
                        });
                      },
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
                    ),
                    buildEditableField(
                      companyNameController,
                      'Company Name',
                      companyNameEditMode,
                      () {
                        setState(() {
                          companyNameEditMode = !companyNameEditMode;
                        });
                      },
                    ),
                    buildEditableField(
                      siteNameController,
                      'Site Name',
                      siteNameEditMode,
                      () {
                        setState(() {
                          siteNameEditMode = !siteNameEditMode;
                        });
                      },
                    ),
                    buildEditableField(
                      siteNumberController,
                      'Site Number',
                      siteNumberEditMode,
                      () {
                        setState(() {
                          siteNumberEditMode = !siteNumberEditMode;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableField(TextEditingController controller, String labelText, bool isEditMode, VoidCallback onEditPressed) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                icon: Icon(isEditMode ? Icons.done : Icons.edit),
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


