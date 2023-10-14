import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/components/sp_navbar.dart';
import 'package:mobile/components/sm_navbar.dart';
import 'package:mobile/first_page.dart';
import 'package:mobile/login_page.dart';
import 'package:mobile/signup_page.dart';
import 'package:mobile/sm_cartpage.dart';
import 'package:mobile/sm_homepage.dart';
import 'package:mobile/sm_orderspage.dart';
import 'package:mobile/sm_profilepage.dart';
import 'package:mobile/sp_profilepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCs1O7UHs5B_ObQee7HAWZvhygcEyUblyA",
      authDomain: "csse-53.firebaseapp.com", // Update with your authDomain
      projectId: "csse-53", // Update with your projectId
      storageBucket: "csse-53.appspot.com", // Update with your storageBucket
      messagingSenderId: "627858556749", // Update with your messagingSenderId
      appId: "1:627858556749:android:94fa0cb323c8b46f8d1904",
    ),
  );
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: FirstPage(),
      // onGenerateRoute: (settings) {
      //   if (settings.name == '/sm_cart') {
      //     // Retrieve the selectedItems list from the arguments
      //     final List<String> selectedItems = settings.arguments as List<String>;
      //     return MaterialPageRoute(
      //       builder: (context) => SMCartPage(selectedItems: selectedItems),
      //     );
      //   }
      //   return null;
      // },
      routes: <String, WidgetBuilder>{
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/sm_navbar': (context) {
          // Retrieve the user data from arguments
          final Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return SMNavBar(userData: userData);
        },
        '/sm_home': (context) {
          // Retrieve the user data from arguments
          final Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return SMHomePage(userData: userData);
        },
        '/sm_profile': (context) {
          // Retrieve the user data from arguments
          final Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return SMProfilePage(userData: userData);
        },
        '/sp_profile': (context) {
          // Retrieve the user data from arguments
          final Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return SPProfilePage(userData: userData);
        },
        '/sm_cart': (context) {
          // Retrieve the user data and selectedItems from arguments
          final Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final List<String> selectedItems = userData['selectedItems'] as List<String>;
          return SMCartPage(selectedItems: selectedItems, userData: userData);
        },
        '/sm_orders': (context) {
          // Retrieve the user data from arguments
          final Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return SMOrdersPage(userData: userData);
        },
        '/sp_navbar': (context) {
          // Retrieve the user data from arguments
          final Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return SPNavBar(userData: userData);
        },
      },
    );
  }
}
