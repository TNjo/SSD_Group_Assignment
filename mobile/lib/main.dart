// import 'package:flutter/material.dart';
// import 'package:device_preview/device_preview.dart';

// import 'package:mobile/components/sp_navbar.dart';
// import 'package:mobile/components/sm_navbar.dart';

// import 'package:mobile/first_page.dart';
// import 'package:mobile/login_page.dart';
// import 'package:mobile/signup_page.dart';

// import 'package:mobile/sm_cartpage.dart';
// import 'package:mobile/sm_homepage.dart';
// import 'package:mobile/sm_orderspage.dart';
// import 'package:mobile/sm_profilepage.dart';

// void main() => runApp(
//       DevicePreview(
//         builder: (context) => MyApp(), // Wrap your app
//       ),
//     );
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//       home: FirstPage(), // Set the initial screen to Screen1.
//       routes: <String, WidgetBuilder>{
//         '/login':(context) => LoginPage(),
//         '/signup':(context) => SignupPage(),
//         '/sm_navbar':(context) => SMNavBar(),
//         '/sm_home':(context) => SMHomePage(),
//         '/sm_profile':(context) => SMProfilePage(),
//         '/sm_cart':(context) => SMCartPage(),
//         '/sm_orders':(context) => SMOrdersPage(),

//         '/sp_navbar':(context) => SPNavBar()
//       },
//   );
//   }
// }


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
      routes: <String, WidgetBuilder>{
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/sm_navbar': (context) => SMNavBar(),
        '/sm_home': (context) => SMHomePage(),
        '/sm_profile': (context) => SMProfilePage(),
        '/sm_cart': (context) => SMCartPage(),
        '/sm_orders': (context) => SMOrdersPage(),
        '/sp_navbar': (context) => SPNavBar(),
      },
    );
  }
}
