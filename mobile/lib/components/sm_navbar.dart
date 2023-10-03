import 'package:flutter/material.dart';
import 'package:mobile/sm_cartpage.dart';
import 'package:mobile/sm_homepage.dart';
import 'package:mobile/sm_orderspage.dart';
import 'package:mobile/sm_profilepage.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class SMNavBar extends StatefulWidget {
  @override
  _SMNavBarState createState() => _SMNavBarState();
}

class _SMNavBarState extends State<SMNavBar> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();

    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4, // Update the length to 4
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        labels: const ["Home","Profile","Cart", "Orders"], // Update labels
        icons: const [
          Icons.home,
          Icons.person,          
          Icons.shopping_cart,
          Icons.shopping_basket, // Add the Orders icon
        ], // Update icons
        badges: [
          null,
          null,
          const MotionBadgeWidget(
            isIndicator: true,
            color: Colors.red,
            size: 5,
            show: true,
          ),
          const MotionBadgeWidget(
            text: '9',
            textColor: Colors.white,
            color: Colors.red,
            size: 18,
          ),
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Color.fromARGB(255, 0, 0, 0),
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Color.fromARGB(255, 255, 255, 255),
        tabIconSelectedColor: const Color.fromARGB(255, 0, 0, 0),
        tabBarColor: Color.fromARGB(255, 248, 204, 57),
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: <Widget>[
          SMHomePage(),   // Home Page
          SMProfilePage(),        // Cart Page
          SMCartPage(),    // Profile Page
          SMOrdersPage(),        // Orders Page
        ],
      ),
    );
  }
}



