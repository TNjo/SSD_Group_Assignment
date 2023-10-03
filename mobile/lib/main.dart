import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'package:mobile/first_page.dart';
import 'package:mobile/login_page.dart';
import 'package:mobile/components/sm_navbar.dart';
import 'package:mobile/sm_cartpage.dart';
import 'package:mobile/sm_homepage.dart';
import 'package:mobile/sm_orderspage.dart';
import 'package:mobile/sm_profilepage.dart';

void main() => runApp(
      DevicePreview(
        builder: (context) => MyApp(), // Wrap your app
      ),
    );
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: FirstPage(), // Set the initial screen to Screen1.
      routes: <String, WidgetBuilder>{
        '/login':(context) => LoginPage(),
        '/sm_navbar':(context) => SMNavBar(),
        '/sm_home':(context) => SMHomePage(),
        '/sm_profile':(context) => SMProfilePage(),
        '/sm_cart':(context) => SMCartPage(),
        '/sm_orders':(context) => SMOrdersPage(),
      },
  );
  }
}
