import 'package:flutter/material.dart';
import 'package:mobile/screens/sm_cartpage.dart';
import 'package:mobile/screens/sm_homepage.dart';
import 'package:mobile/screens/sm_orderspage.dart';
import 'package:mobile/screens/sm_profilepage.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class SMNavBar extends StatefulWidget {
  final Map<String, dynamic> userData;

  SMNavBar({required this.userData});

  @override
  _SMNavBarState createState() => _SMNavBarState(userData: userData);
}

class _SMNavBarState extends State<SMNavBar> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  List<String> selectedItems = []; // Define the selected items list

  final Map<String, dynamic> userData;

  _SMNavBarState({required this.userData});

  @override
  void initState() {
    super.initState();

    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
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
    print("UserData: ${widget.userData}");
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        labels: const ["Home", "Profile", "Cart", "Orders"],
        icons: const [
          Icons.home,
          Icons.person,
          Icons.shopping_cart,
          Icons.shopping_basket,
        ],
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
          SMHomePage(userData: userData), // Pass userData to Home Page
          SMProfilePage(userData: userData), // Pass userData to Profile Page
          SMCartPage(selectedItems: selectedItems, userData: userData), // Pass userData to Cart Page
          SMOrdersPage(userData: userData), // Pass userData to Orders Page
        ],
      ),
    );
  }
}

