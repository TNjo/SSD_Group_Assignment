import 'package:mobile/first_page.dart';
//import 'package:mobile/login.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

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
        //'/login':(context) => LoginPage(),
        // '/screen4':(context) => Screen4(),
        // '/screen5':(context) => Screen5(),
        // '/screen6':(context) => Screen6(),
        // '/screen7':(context) => Screen7(),
        // '/form':(context) => FormScreen(),
      },
  );
  }
}
